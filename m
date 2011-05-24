Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab1EXILc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 04:11:32 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58216 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab1EXIL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 04:11:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@elte.hu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Containers <containers@lists.osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Namespace file descriptors for 2.6.40
References: <m11uzrvd26.fsf@fess.ebiederm.org>
	<BANLkTim4q5dK6nOb=pVKbk1c8b-Nh_hBfA@mail.gmail.com>
	<m1boyvpo9r.fsf@fess.ebiederm.org>
	<1306048393.4092.8.camel@mulgrave.site>
	<20110522084224.GA12279@elte.hu> <m1k4dgr35i.fsf@fess.ebiederm.org>
	<1306221981.10201.8.camel@mulgrave.site>
Date: Tue, 24 May 2011 01:11:19 -0700
In-Reply-To: <1306221981.10201.8.camel@mulgrave.site> (James Bottomley's
	message of "Tue, 24 May 2011 11:26:21 +0400")
Message-ID: <m1aaeco6vs.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19AwTDmqav5brbacaRSshHHL6QleJimnmg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> On Tue, 2011-05-24 at 00:03 -0700, Eric W. Biederman wrote:
>> Ingo Molnar <mingo@elte.hu> writes:
>> 
>> > I agree with Linus's notion in this thread though, a core kernel change should 
>> > generally not worry about hooking up rare-arch system calls (concentrate on the 
>> > architectures that get tested most) - those are better enabled gradually 
>> > anyway.
>> 
>> The way I read it he was complaining about my having parisc bits and
>> asking for my branch to be merged before the parisc bits had been
>> merged.  Which I credit as a fair complaint.  If I am going to depend on
>> other peoples trees I should wait.
>> 
>> At the same time when I am busy looking for every possible source of
>> trouble and putting code into net-next to detect pending conflicts,
>> and when maintainers complain when I ask for review that my patches
>> conflict with their patches.  Being a contentious developer I am
                                         ^^^^^^^^^^^ conscientious
I didn't realize it was possible to make that typo.

>> inclined to do something.
>
> Right ... and the problem is that someone has to care, because the
> conflict will show up in linux-next.  I think Stephen Rothwell would
> appreciate us making his life easier rather than leaving it to him to
> sort out the problems.
>
>> Now that the reality has sunk in that it means waiting for other peoples
>> code to be merged before I request for my changes to be merged I don't
>> think I will structure a tree that way again while I remember.
>
> Right.   This is quite a common occurrence in SCSI (mostly changes
> entangled with block or libata).  If you don't feel comfortable running
> a postmerge tree, just send me the bits and I'll do it (after all it
> works either way around: I can pull in the syscalls and depend on your
> tree rather than vice versa).

Well for the moment I don't see too many problems.  I sent another pull
request to Linus earlier today now that your changes are in.  So I am
hoping either Linus will pull my tree or someone will educate me on what
he will Linus will accept.

Right now my tree is tested and in a good state.  Heck I'm running it
to send this email.  So I am reluctant to change anything without clear
feedback.

James when you refer to a postmerge tree what are the dynamics/semantics
usually associated with that?  Is this a tree that gets pulled a couple
of times?  Once with the non-conflicting bits.  Another time when the
bits it depends on have been merged?  Or is this a tree that gets pulled
after the merge window entirely?

Eric
