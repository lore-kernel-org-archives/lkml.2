Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab1EHCTs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 22:19:48 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55307 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1EHCTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 22:19:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jamal <hadi@cyberus.ca>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Linux Containers <containers@lists.osdl.org>,
        Renato Westphal <renatowestphal@gmail.com>
Subject: Re: [PATCH 7/7] ns: Wire up the setns system call
References: <m1tyd7p7tq.fsf@fess.ebiederm.org>
	<1304735101-1824-1-git-send-email-ebiederm@xmission.com>
	<1304735101-1824-7-git-send-email-ebiederm@xmission.com>
	<1304798775.6123.18.camel@mulgrave.site>
Date: Sat, 07 May 2011 19:19:37 -0700
In-Reply-To: <1304798775.6123.18.camel@mulgrave.site> (James Bottomley's
	message of "Sat, 07 May 2011 15:06:15 -0500")
Message-ID: <m162pm53ye.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX184uexCFTW17bqJ8IZrCGl1KQaVh+PwAk0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> On Fri, 2011-05-06 at 19:25 -0700, Eric W. Biederman wrote:
>> v2: Most of the architecture support added by Daniel Lezcano <dlezcano@fr.ibm.com>
>> v3: ported to v2.6.36-rc4 by: Eric W. Biederman <ebiederm@xmission.com>
>> v4: Moved wiring up of the system call to another patch
>> v5: ported to v2.6.39-rc6
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>
> We already have several syscalls queued up for parisc:
>
> http://git.kernel.org/?p=linux/kernel/git/jejb/parisc-2.6.git;a=shortlog;h=refs/heads/misc
>
> So if you could make this patch over them (or over linux-next), that
> would help the merge process.

I will take a look. I was rather pleasantly surprised that no other
system call conflicts had shown up before now.

This is unfortunately one of those areas where it is almost impossible
to avoid conflicts.

Do you know if there is any chance that the parisc tree might get
rebased or anything horrible like that?

If not I think I will just pull the hunk of the parisc tree with the syscalls
e38f5b745075828ac51b12c8c95c85a7be4a3ec7...2e7bad5f34b5beed47542490c760ed26574e38ba
into my tree so I don't have to worry about merge order.

Eric

