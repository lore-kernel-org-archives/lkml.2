Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1AOS0D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 13:26:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33510 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab1AOS0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 13:26:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=pqW1l2LFyys1DOg3WokuLSjAJSZaV+5do8k8SiWbQ1A3jNQ6citrbrldYeDS056RNm
         YNyEKW88+VOD4LN0pUVpiP/lbDmCAazHkzEueHd8296wM9+7yHpk9lmaBPCWL6ZFKUfk
         ErEsh0Zk0NXucf0BRFIKR1ZI93EUWb7SsYCe4=
MIME-Version: 1.0
In-Reply-To: <1295030453.18445.63.camel@mulgrave.site>
References: <1295030453.18445.63.camel@mulgrave.site>
From: Bart Van Assche <bvanassche@acm.org>
Date: Sat, 15 Jan 2011 19:25:39 +0100
X-Google-Sender-Auth: Aw7wzg2oJW3dFraGDz2w35t5USo
Message-ID: <AANLkTimrsN_dg+0H27dov5ZfdQieTsBMPXQCawBkWZnN@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI postmerge patches for 2.6.38 merge window
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 7:40 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
>
> This is a set of three patches I've been carrying that had a
> dependencies on pieces of the block tree (which went in yesterday).
> It's been rebased to go cleanly on top of current git head (and elimnate
> some of the merge cruft of creating a postmerge tree).  All of the
> patches have been in Linux-next for several weeks.
>
> The two sd/sr patches are just completion of the media events
> infrastructure which was in the block tree.  The main chunk is the
> addition of the LIO in-kernel target infrastructure which is one of the
> two competing target infrastructures which have been out of tree for
> several years now.  Thanks to quite a lot of effort (particularly from
> Christoph Hellwig) cleaning it up, I think it's ready for mainline
> inclusion.  This piece is just the target infrastructure; we'll begin
> adding the in-kernel drivers and the migration hooks for STGT (our
> original user land target driver) over the next merge window.
>
> The patch is available here:
>
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-post-merge-2.6.git
>
> The short changelog is:
>
> Nicholas Bellinger (1):
>      target: Add LIO target core v4.0.0-rc6
> [ ... ]

As anyone can see in the source file drivers/target/target_core_mib.c
this patch adds a significant number of new files to procfs. I thought
that this was considered unacceptable since a long time ? Has anything
changed ?

See also http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/target/target_core_mib.c.

Bart.
