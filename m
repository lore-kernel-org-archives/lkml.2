Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab2ECPiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:38:11 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:45391 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab2ECPiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:38:09 -0400
Date: Thu, 3 May 2012 11:37:43 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: David Vrabel <dvrabel@cantab.net>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, david.vrabel@citrix.com
Subject: Re: [Xen-devel] [PATCH 8/8] xen/setup: Combine the two hypercall functions - since they are quite similar.
Message-ID: <20120503153743.GA3464@andromeda.dapyr.net>
References: <1334596539-18172-1-git-send-email-konrad.wilk@oracle.com> <1334596539-18172-9-git-send-email-konrad.wilk@oracle.com> <4FA272CD.90808@cantab.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA272CD.90808@cantab.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 12:58:05PM +0100, David Vrabel wrote:
> On 16/04/12 18:15, Konrad Rzeszutek Wilk wrote:
> > They use the same set of arguments, so it is just the matter
> > of using the proper hypercall.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Acked-by: David Vrabel <david.vrabel@citrix.com>
> 
> But would it be better to fold this into the previous patch?

Nah, one logical change per patch.
> 
> David
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
