Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab2KFDgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 22:36:46 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40708 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab2KFDgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 22:36:43 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
References: <20121104042802.GA11295@srcf.ucam.org>
	<1352020487.2427.5.camel@dabdike.int.hansenpartnership.com>
	<20121104135251.GA17894@srcf.ucam.org> <87d2zsmv8r.fsf@xmission.com>
	<509766DB.9090906@zytor.com> <87625kh5r2.fsf@xmission.com>
	<20121105123858.GB4374@srcf.ucam.org> <87sj8nc137.fsf@xmission.com>
	<20121105202557.GA16076@srcf.ucam.org> <87hap3zbw7.fsf@xmission.com>
	<20121106031219.GB24235@srcf.ucam.org>
Date: Mon, 05 Nov 2012 19:36:32 -0800
In-Reply-To: <20121106031219.GB24235@srcf.ucam.org> (Matthew Garrett's message
	of "Tue, 6 Nov 2012 03:12:19 +0000")
Message-ID: <87fw4nv1vj.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+VuCtRnOFLmgjFqhN3uzCBvaJ/rUku65w=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Matthew Garrett <mjg59@srcf.ucam.org>
X-Spam-Relay-Country: 
Subject: Re: [RFC] Second attempt at kernel secure boot support
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> On Mon, Nov 05, 2012 at 06:46:32PM -0800, Eric W. Biederman wrote:
>> Matthew Garrett <mjg59@srcf.ucam.org> writes:
>> 
>> > On Mon, Nov 05, 2012 at 11:16:12AM -0800, Eric W. Biederman wrote:
>> >> Matthew Garrett <mjg59@srcf.ucam.org> writes:
>> >> > No, in the general case the system will do that once it fails to find a 
>> >> > bootable OS on the drive.
>> >> 
>> >> In the general case there will be a bootable OS on the drive.
>> >
>> > That's in no way a given.
>> 
>> You have it backwards.  The conclusion here is that having a case where
>> a non-interactive install is possible is not a given.
>
> I deal with customers who perform non-interactive installs. The fact 
> that you don't care about that use case is entirely irrelevant to me, 
> because you're not the person that I am obliged to satisfy.

I have spent what feels like half my life doing automatic installs.  I
care a lot and I understand the requirements.  I also see through
misstatements about reality used to justify stupid design decisions.

For automated installs you don't have to satisfy me.  Feel free to
deliver a lousy solution to your users.   Just don't use your arbitrary
design decisions to justify your kernel patches.

Non-interactive installs do not justify removing all trust from the root
user of a system, disabling suspend to disk and completely rewriting
kexec for the simple expedient removing a couple of lines of code from
your bootloader.

Eric
