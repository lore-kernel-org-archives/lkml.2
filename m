Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab0I2NC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 09:02:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:54726 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab0I2NCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 09:02:25 -0400
Date: Wed, 29 Sep 2010 15:01:31 +0200
From: Jan Kara <jack@suse.cz>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        =?utf-8?Q?Micha=C5=82?= Piotrowski <mkkp4x4@gmail.com>,
        Chuck Ebbert <cebbert@redhat.com>, kernel@lists.fedoraproject.org
Subject: Re: Dirtiable inode bdi default != sb bdi btrfs
Message-ID: <20100929130131.GH3290@quack.suse.cz>
References: <4C9AA546.6050201@cesarb.net>
 <20100923123849.8975fe47.akpm@linux-foundation.org>
 <20100927222548.GG3610@quack.suse.cz>
 <4CA12F01.2@cesarb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA12F01.2@cesarb.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 27-09-10 20:55:45, Cesar Eduardo Barros wrote:
> Em 27-09-2010 19:25, Jan Kara escreveu:
> >[Added CCs for similar ecryptfs warning]
> >On Thu 23-09-10 12:38:49, Andrew Morton wrote:
> >>>[...]
> >>>device fsid 44d595920ddedfa-3ece6b56e80f689e devid 1 transid 22342
> >>>/dev/mapper/vg_cesarbinspiro-lv_home
> >>>SELinux: initialized (dev dm-3, type btrfs), uses xattr
> >>>------------[ cut here ]------------
> >>>WARNING: at fs/fs-writeback.c:87 inode_to_bdi+0x62/0x6d()
> >>>Hardware name: Inspiron N4010
> >>>Dirtiable inode bdi default != sb bdi btrfs
> >   That suggests that we should probably handle such cases in a more generic
> >way by changing the code in inode_init_always(). The patch below makes at
> >least btrfs happy for me... Could you maybe test it? Thanks.
> 
> Applied on top of v2.6.36-rc5-151-g32163f4, running it right now.
> The warning messages no longer happen, and everything seems to be
> working fine.
> 
> Tested-by: Cesar Eduardo Barros <cesarb@cesarb.net>
  Great, thanks for testing.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
