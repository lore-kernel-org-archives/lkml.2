Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab2BMV5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 16:57:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207Ab2BMV5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 16:57:00 -0500
Date: Mon, 13 Feb 2012 16:56:50 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Phillip Susi <psusi@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com,
        Karel Zak <kzak@redhat.com>, maxim.patlasov@gmail.com
Subject: Re: [PATCH 0/2] block: online resize of disk partitions
Message-ID: <20120213215650.GE3130@redhat.com>
References: <1329161438-12602-1-git-send-email-vgoyal@redhat.com>
 <4F3981FE.7090601@ubuntu.com>
 <20120213215039.GD3130@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120213215039.GD3130@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 04:50:39PM -0500, Vivek Goyal wrote:

[..]
> > as well as to allow for the
> > possibility of extending the interface in the future to allow changing
> > the start as well as the length.
> 
> Even if we allow changing start at some point of time, then IOCTL can
> remain the same and just the implementation will change in a backward
> compatible manner. Old tools still will continue to work as they have
> always been, and new ones can start passing "start" too.

Let me thake that back. Changes will not be backward compatible as
if old tools run on new kernel specifying start as 0, then change
will fail on newer kernels which might allow changing start too.

Do you really expect that changing start will really be useful? If yes,
then it does make a case for not leaving "start" undefined.

Thanks
Vivek
