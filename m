Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab2KFFT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 00:19:56 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52545 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab2KFFTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 00:19:54 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
References: <20121104135251.GA17894@srcf.ucam.org>
	<87d2zsmv8r.fsf@xmission.com> <509766DB.9090906@zytor.com>
	<87625kh5r2.fsf@xmission.com> <20121105123858.GB4374@srcf.ucam.org>
	<87sj8nc137.fsf@xmission.com> <20121105202557.GA16076@srcf.ucam.org>
	<87hap3zbw7.fsf@xmission.com> <20121106031219.GB24235@srcf.ucam.org>
	<87fw4nv1vj.fsf@xmission.com> <20121106035352.GA24698@srcf.ucam.org>
Date: Mon, 05 Nov 2012 21:19:46 -0800
In-Reply-To: <20121106035352.GA24698@srcf.ucam.org> (Matthew Garrett's message
	of "Tue, 6 Nov 2012 03:53:52 +0000")
Message-ID: <87hap3s3yl.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+0dFhvS2Fkzrl7OidD/A/qK2HkEl9twBY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0081]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Matthew Garrett <mjg59@srcf.ucam.org>
X-Spam-Relay-Country: 
Subject: Re: [RFC] Second attempt at kernel secure boot support
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> On Mon, Nov 05, 2012 at 07:36:32PM -0800, Eric W. Biederman wrote:
>
>> For automated installs you don't have to satisfy me.  Feel free to
>> deliver a lousy solution to your users.   Just don't use your arbitrary
>> design decisions to justify your kernel patches.
>
> My kernel patches are justified by genuine user requirements. 

Hogwash.

If windows is not present on a system linux can not be used to boot a
compromised version of windows without user knowledge because windows is
not present.

If windows is present on a system then to install linux a user must be
present and push buttons to get the system to boot off of install media.

If a user is present a user presence test may be used to prevent a
bootloader signed with  Microsoft's key from booting linux without the
users consent, and thus prevent Linux from attacking windows users.

Therefore preventing the revokation of a signature with Microsoft's
signature from your bootloader does not justify elaborate kernel
modifications to prevent the booting a compromised version of windows.

Furthermore no matter how hard we try with current techniques there will
eventually be kernel bugs that allow attackers to inject code into the
kernel.  So attempting to fully close that attack vector is
questionable.

> If you 
> don't feel that there's any requirement for the kernel to satisfy the 
> people who use it, you're free to ignore those patches.

I feel allowing the kernel to be hacked to bits and decend into an
unmaintainable mess does not serve the users who use the kernel,
and to prevent that technically poor patches should be rejected.

This helps prevent non-technical considerations from justifying
technically poor decisions.

Eric
