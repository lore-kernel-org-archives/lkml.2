Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab1FHGVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 02:21:54 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56620 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab1FHGVx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 02:21:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=DFzPrsStwd6qulAY2W1bqWJnMGr43hbvahoAFxfphRxy2LjA5MAWQ3WBEyGw6oHb5M
         nc8R5S0pcI30B3pHhIUrqecN+2LcA+x3V5oIU9ms06nUkyjciH3lElC918JB2ISmjoYZ
         CbuLXv7qYGO9Ny2iAKj4acmPkgQ4nlbvILbdc=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110608020102.GA29239@localhost>
References: <20110607213236.634026193@intel.com>
	<20110607160441.db475211.akpm@linux-foundation.org>
	<20110608020102.GA29239@localhost>
Date: Wed, 8 Jun 2011 08:21:52 +0200
Message-ID: <BANLkTik1jbjXs0rWG1cQEWzGYaMy1TmgnQ@mail.gmail.com>
Subject: Re: [PATCH 00/15] writeback fixes and cleanups for 3.0 (v5)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 4:01 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Wed, Jun 08, 2011 at 07:04:41AM +0800, Andrew Morton wrote:
>> On Wed, 08 Jun 2011 05:32:36 +0800
>> Wu Fengguang <fengguang.wu@intel.com> wrote:
>>
>> >
>> > Andrew,
>> >
>> > Here are the intented patches for upstream submission, rebased to v3.0-rc2:
>> >
>> >     [PATCH 01/15] writeback: introduce .tagged_writepages for the WB_SYNC_NONE sync stage
>> >     [PATCH 02/15] writeback: update dirtied_when for synced inode to prevent livelock
>> >     [PATCH 03/15] writeback: introduce writeback_control.inodes_cleaned
>> >     [PATCH 04/15] writeback: try more writeback as long as something was written
>> >     [PATCH 05/15] writeback: the kupdate expire timestamp should be a moving target
>> >     [PATCH 06/15] writeback: refill b_io iff empty
>> >     [PATCH 07/15] writeback: split inode_wb_list_lock into bdi_writeback.list_lock
>> >     [PATCH 08/15] writeback: elevate queue_io() into wb_writeback()
>> >     [PATCH 09/15] writeback: avoid extra sync work at enqueue time
>> >     [PATCH 10/15] writeback: add bdi_dirty_limit() kernel-doc
>> >     [PATCH 11/15] writeback: skip balance_dirty_pages() for in-memory fs
>> >     [PATCH 12/15] writeback: remove writeback_control.more_io
>> >     [PATCH 13/15] writeback: remove .nonblocking and .encountered_congestion
>> >     [PATCH 14/15] writeback: trace event writeback_single_inode
>> >     [PATCH 15/15] writeback: trace event writeback_queue_io
>>
>> Looks OK to me, although I think a few of the changelogs are lacking
>> important details.
>
> Thanks.
>
>> > They are git pullable from
>> >
>> > git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git fs-writeback
>> >
>>
>> Please ask Stephen to suck this into linux-next when ready.
>
> OK, now it includes the updated patches. It's based on v3.0-rc2 and
> also compile/runs OK with 3.0.0-rc2-next-20110607.
>

So, did I a few hours ago... Running a kernel with your patchset
applied right now.

- Sedat -

> Stephen, would you help add this git branch to linux-next? Thank you.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git#fs-writeback
>
> Thanks,
> Fengguang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
