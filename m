Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab2BHSPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 13:15:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab2BHSPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 13:15:17 -0500
Date: Wed, 8 Feb 2012 13:14:57 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: axboe@kernel.dk
Cc: tj@kernel.org, sjayaraman@suse.com, gouders@et.bocholt.fh-gelsenkirchen.de,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] floppy: Fix couple of crashes during init and module
 removal
Message-ID: <20120208181457.GC19323@redhat.com>
References: <1327935591-26812-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327935591-26812-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 09:59:49AM -0500, Vivek Goyal wrote:
> Hi Jens,
> 
> Here are couple of fixes for floppy driver. These fixes need to go in for 3.3.
> Original discussion thread is here.
> 
> https://lkml.org/lkml/2012/1/24/138
> 
> I am reposting the patches in a separate thread as it might be easier for you
> to pick up the patches.
> 

Hi Jens,

Can you please apply these two floppy driver fixes.

Thanks
Vivek

> Thanks
> Vivek
> 
> Vivek Goyal (2):
>   floppy: Cleanup disk->queue before caling put_disk() if add_disk()
>     was never called
>   floppy: Fix a crash during rmmod
> 
>  drivers/block/floppy.c |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
> 
> -- 
> 1.7.4.4
