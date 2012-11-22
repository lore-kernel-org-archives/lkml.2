Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab2KVXDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 18:03:11 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61727 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab2KVS3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:29:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAAJw_ZsQdLO5qLdGPzmPf+N2D6CZw+S-4mvRGnxfARL71LuRaw@mail.gmail.com>
References: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com>
	<20121120180949.GG1408@quack.suse.cz>
	<CAAJw_ZsQdLO5qLdGPzmPf+N2D6CZw+S-4mvRGnxfARL71LuRaw@mail.gmail.com>
Date: Thu, 22 Nov 2012 22:30:38 +0800
Message-ID: <CAAJw_ZsAyB0z0TF1mqPz1Z+H+tg7W6LVzNLKf0BkuF3u8TTMuQ@mail.gmail.com>
Subject: Re: Recent kernel "mount" slow
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 11:46 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Wed, Nov 21, 2012 at 2:09 AM, Jan Kara <jack@suse.cz> wrote:
>>   I haven't heard about such problem so far. What filesystem are you using?
>
> I've tried ext2/ext3/ext4/reiserfs/btrfs ... all seems to be slower
> than before. Seems to be fs independent.
>
>> Can you quantify 'is slower'? Bisecting would be welcome of course.
>
> Haven't measure, but it seems to be 1 sec instead of .3 sec to mount.
> I'll start bisecting:(
> So, since I've 6 mounts on start up, now it takes 4 seconds longer to boot up.

I started bisecting, and it seems to have multiple points of slowing
down. The latest kernel is really slow mounting /dev/sda1 (fs
independent) ... 0.529sec. Kernel 3.6.0 took 0.012sec, Kernel
3.7.0-rc2 took 0.168sec. Again, these are very early results. I'm
verifying them again.


Jeff
