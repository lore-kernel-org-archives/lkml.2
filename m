Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab1CGPuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 10:50:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612Ab1CGPuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 10:50:09 -0500
Date: Mon, 7 Mar 2011 10:50:06 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: jaxboe@fusionio.com
Cc: oleg@redhat.com, paulmck@linux.vnet.ibm.com,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] blk-throttle: Couple of cleanup and fixes for limit
 update code
Message-ID: <20110307155006.GF9540@redhat.com>
References: <1298331770-20079-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298331770-20079-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 06:42:48PM -0500, Vivek Goyal wrote:
> Hi Jens,
> 
> Couple of throttle fixes seem to have fallen through cracks.
> 
> https://lkml.org/lkml/2010/12/15/331
> 
> I am reposting it for inclusion. Please let me know if you have any concerns.
> Oleg and Paul acked the patch in the past so I am retaining their Reviewed-by:
> lines.
> 

Hi Jens,

Can you please apply following patches for 2.6.39. These are good for fixing
couple of race conditions in block throttle code w.r.t limit updates.
Please let me know if you have concernes with these patches.

Thanks
Vivek

> Thanks
> Vivek
> 
> Vivek Goyal (2):
>   blk-throttle: process limit change only through one function
>   blk-throttle: Some cleanups and race fixes in limit update code
> 
>  block/blk-throttle.c |  104 ++++++++++++++++++++------------------------------
>  1 files changed, 41 insertions(+), 63 deletions(-)
