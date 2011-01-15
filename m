Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab1AOVGC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 16:06:02 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58890 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab1AOVGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 16:06:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tWBPSoGOHOWe+8kQqe9uokGFBBkpjn07+r5fdDPZh/puQvug3vo/5la7UfjxSvWLOl
         ZjSGAKed4KU2VRuvhdon9kpxSCe0904Sh3xQtSmT7Zkkpj/rdng8ddO4MJqfsSK5FZmq
         /eIQype4woIELoSEITEjgiTtU+wZe7fxq6vGs=
Message-ID: <4D320C32.3070604@garzik.org>
Date: Sat, 15 Jan 2011 16:05:54 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: James Bottomley <James.Bottomley@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] SCSI postmerge patches for 2.6.38 merge window
References: <1295030453.18445.63.camel@mulgrave.site> <AANLkTimrsN_dg+0H27dov5ZfdQieTsBMPXQCawBkWZnN@mail.gmail.com>
In-Reply-To: <AANLkTimrsN_dg+0H27dov5ZfdQieTsBMPXQCawBkWZnN@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2011 01:25 PM, Bart Van Assche wrote:
> On Fri, Jan 14, 2011 at 7:40 PM, James Bottomley
> <James.Bottomley@suse.de>  wrote:
>>
>> This is a set of three patches I've been carrying that had a
>> dependencies on pieces of the block tree (which went in yesterday).
>> It's been rebased to go cleanly on top of current git head (and elimnate
>> some of the merge cruft of creating a postmerge tree).  All of the
>> patches have been in Linux-next for several weeks.
>>
>> The two sd/sr patches are just completion of the media events
>> infrastructure which was in the block tree.  The main chunk is the
>> addition of the LIO in-kernel target infrastructure which is one of the
>> two competing target infrastructures which have been out of tree for
>> several years now.  Thanks to quite a lot of effort (particularly from
>> Christoph Hellwig) cleaning it up, I think it's ready for mainline
>> inclusion.  This piece is just the target infrastructure; we'll begin
>> adding the in-kernel drivers and the migration hooks for STGT (our
>> original user land target driver) over the next merge window.
>>
>> The patch is available here:
>>
>> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-post-merge-2.6.git
>>
>> The short changelog is:
>>
>> Nicholas Bellinger (1):
>>       target: Add LIO target core v4.0.0-rc6
>> [ ... ]
>
> As anyone can see in the source file drivers/target/target_core_mib.c
> this patch adds a significant number of new files to procfs. I thought
> that this was considered unacceptable since a long time ? Has anything
> changed ?
>
> See also http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/target/target_core_mib.c.

Nothing has changed WRT procfs, and you are correct.

But it's in now.  Submit a patch to fix this particular crapola!  :)

	Jeff


