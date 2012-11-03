Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762232Ab2KCArN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 20:47:13 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43299 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab2KCArL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 20:47:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
References: <20121101210634.GA19723@srcf.ucam.org>
	<20121101213127.5967327f@pyramind.ukuu.org.uk>
	<20121101212843.GA20309@srcf.ucam.org>
	<20121101213751.377ebaa8@pyramind.ukuu.org.uk>
	<20121101213452.GA20564@srcf.ucam.org>
	<20121101215817.79e50ec2@pyramind.ukuu.org.uk>
	<20121101215752.GA21154@srcf.ucam.org> <87625ogzje.fsf@xmission.com>
	<20121102140057.GA4668@srcf.ucam.org> <87liejacix.fsf@xmission.com>
	<20121103002033.GA18691@srcf.ucam.org>
Date: Fri, 02 Nov 2012 17:47:02 -0700
In-Reply-To: <20121103002033.GA18691@srcf.ucam.org> (Matthew Garrett's message
	of "Sat, 3 Nov 2012 00:20:34 +0000")
Message-ID: <87sj8rwm0p.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+BbJDXMMNauPTnW7FRK6ejbsG1BwtpT40=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Matthew Garrett <mjg59@srcf.ucam.org>
X-Spam-Relay-Country: 
Subject: Re: [RFC] Second attempt at kernel secure boot support
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> On Fri, Nov 02, 2012 at 03:03:02PM -0700, Eric W. Biederman wrote:
>
>> I don't want my system p0wned in the first place and I don't want to run
>> windows.  Why should I trust Microsoft's signing key?
>
> There's no reason to. Systems that don't trust Microsoft's signing key 
> have no reason to be concerned about Microsoft revocation. 
> Unfortunately, that's not the only set of people we have to worry
> about.

No reason to?  How can I configure an off the shelf system originally
sold with windows 8 installed to boot in UEFI secure boot mode using
shim without trusting Microsoft's key?

Eric
