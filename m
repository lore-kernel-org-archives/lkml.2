Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab2KBItl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 04:49:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44273 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555Ab2KBItf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 04:49:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
References: <CACLa4pvh3v3Mhq8oe3dzRL8ytBgmitPkCGUSfVCR5WdQopjRMQ@mail.gmail.com>
	<1351783096.2391.77.camel@dabdike.int.hansenpartnership.com>
	<CACLa4pu0yoB6CQX=3nuAT2vz4=oTNfM9fjMUvFXKJovYu+y4fw@mail.gmail.com>
	<1351803800.2391.96.camel@dabdike.int.hansenpartnership.com>
	<20121101210634.GA19723@srcf.ucam.org>
	<20121101213127.5967327f@pyramind.ukuu.org.uk>
	<20121101212843.GA20309@srcf.ucam.org>
	<20121101213751.377ebaa8@pyramind.ukuu.org.uk>
	<20121101213452.GA20564@srcf.ucam.org>
	<20121101215817.79e50ec2@pyramind.ukuu.org.uk>
	<20121101215752.GA21154@srcf.ucam.org>
Date: Fri, 02 Nov 2012 01:49:25 -0700
In-Reply-To: <20121101215752.GA21154@srcf.ucam.org> (Matthew Garrett's message
	of "Thu, 1 Nov 2012 21:57:52 +0000")
Message-ID: <87625ogzje.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18/qlkeAwnhhYHwCkqCXIoTAs4pJCjrZKo=
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

> On Thu, Nov 01, 2012 at 09:58:17PM +0000, Alan Cox wrote:
>> On Thu, 1 Nov 2012 21:34:52 +0000
>> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> > I think you've misunderstood. Blacklist updates are append only.
>> 
>> I think you've misunderstood - thats a technical detail that merely
>> alters the cost to the people who did something improper.
>
> Winning a case is cold comfort if your software has been uninstallable 
> for the years it took to get through the courts. If others want to take 
> that risk, fine.

When the goal is to secure Linux I don't see how any of this helps.
Windows 8 compromises are already available so if we turn most of these
arguments around I am certain clever attackers can go through windows to
run compromised kernel on a linux system, at least as easily as the
reverse.

Short of instructing UEFI to stop trusting the Microsoft signing key I
don't see any of the secureboot dance gaining any security of computers
running linux or security from keys being revoked for non-sense reasons.

Eric
