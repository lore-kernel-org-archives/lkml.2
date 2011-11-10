Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab1KJCdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 21:33:39 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:51788 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab1KJCdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 21:33:38 -0500
Date: Thu, 10 Nov 2011 11:33:34 +0900
From: Simon Horman <horms@verge.net.au>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>, kexec@lists.infradead.org,
        ebiederm@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kdump: kill redundant code
Message-ID: <20111110023333.GL9202@verge.net.au>
References: <20111109070452.GA25768@darkstar.nay.redhat.com>
 <20111109152012.GA12537@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109152012.GA12537@redhat.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 10:20:13AM -0500, Vivek Goyal wrote:
> On Wed, Nov 09, 2011 at 03:04:52PM +0800, Dave Young wrote:
> > in while loop below, hole_end > crashk_res.end is impossible:
> > while (hole_end <= crashk_res.end) {
> > 	[snip]
> > }
> > Killing the check code here
> > 
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> 
> Makes sense.
> 
> Acked-by: Vivek Goyal <vgoyal@redhat.com>

Indeed it does. I wonder if this was always so redundant.

Acked-by: Simon Horman <horms@verge.net.au>
