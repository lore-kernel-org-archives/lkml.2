Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab0IXShN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:37:13 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:52089 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab0IXShM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:37:12 -0400
Message-ID: <4C9CEFD6.3000106@kernel.dk>
Date: Fri, 24 Sep 2010 20:37:10 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFT PATCH] amiga, atari floppy: Use one request queue per disk
References: <1285271646-2768-1-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1285271646-2768-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-23 21:54, Vivek Goyal wrote:
> Hi,
> 
> We seem to have deprecated the notion of sharing request queue across gendisks. Now we need to instanciate one request queue per disk.
> 
> There see to be still some drivers sharing request queue across disks. Arch
> specific floppy drivers like amiga and atari are doing so.
> 
> These are two patches which should fix the issue. But these patches are
> completely untested. Not even compilte tested. Don't have hardware to test
> them. 
> 
> Would be great if somebody who has the hardware can lend a hand here to
> see if these patches work.

I have (tentatively) added both patches to for-2.6.37/drivers. I used the
latter version of 2/2.

-- 
Jens Axboe

