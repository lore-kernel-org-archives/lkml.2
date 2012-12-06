Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab2LFAm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 19:42:57 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:8055 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932087Ab2LFAmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 19:42:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlUMADjpv1B5LLKS/2dsb2JhbABEDrgXhgAXc4IeAQEEATocKAsIAxEDAQIBLhQlAxMOARKICgUNwlkUjCODYGEDlgKBHY8rgjVR
Date: Thu, 6 Dec 2012 11:42:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Martin Steigerwald <Martin@lichtvoll.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121206004234.GA27172@dastard>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
 <201212051718.44017.Martin@lichtvoll.de>
 <20121205163303.GG18885@thunk.org>
 <201212051824.05621.Martin@lichtvoll.de>
 <20121205173415.GI18885@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121205173415.GI18885@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 12:34:15PM -0500, Theodore Ts'o wrote:
> Because it's the on-disk encoding, when btrfs uses extra bits for its
> btrfs-specific inode flags, it means that I need to avoid using those
> bits in ext4, if it's a flag that needs to also be exposed via
> chattr/lsattr.

What, you mean the ones they posted to -fsdevel for peer review?

http://marc.info/?t=129914133000001&r=1&w=2

> P.S.  The main reason why it would have been better for btrfs
> developers to have consulted me is that they also depend on
> lsattr/chattr, and those programs are part of e2fsprogs.

They did consult you directly, Ted. Here's the header from V2 of the
patch indicating that you are directly cc'd:

  Message-ID: <4D871243.2060001@cn.fujitsu.com>
  Date: Mon, 21 Mar 2011 16:54:27 +0800
  From: liubo <liubo2009@cn.fujitsu.com>
  User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US;
          rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11
          Thunderbird/3.0b2
  MIME-Version: 1.0
  To: Linux Btrfs <linux-btrfs@vger.kernel.org>
  CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
          Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@lst.de>,
          tytso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>
  Subject: [PATCH 1/2 v2] Btrfs: add datacow flag in inode flag

Apples and oranges, Ted. You didn't post your change anywhere,
unlike the btrfs guys who did the right thing. Please stop trying to
blame someone else for your actions.

> That being said, you'll note that unlike Dave, I have
> **not** thrown a hissy fit when btrfs grabbed bits from the inode
> field, even though quite a bit more bits allocated for the inode flags
> than the fallocate flags.

IOWs, pointing out that the standard peer review process has been
bypassed is "throwing a hissy fit"? And Linus calls it "being a
pissy bitch". To me this is acknoweldgement of the fact that
something wrong was done, but the actors can't bring themselves to
directly admit it and so are resorting to name calling and
blame-shifting to discredit the messenger and therefore the message.

Or perhaps Linus has given us the go-ahead to push random unreviewed
syscall changes through subsystem trees after holding private
discussions between a handful of developers like has happened here.

Cheers.

Dave.
-- 
Dave Chinner
david@fromorbit.com
