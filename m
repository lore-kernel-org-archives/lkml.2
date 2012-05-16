Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197Ab2EPGgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:36:17 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42246 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759125Ab2EPGgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:36:16 -0400
Date: Wed, 16 May 2012 09:35:40 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Christoph Lameter <cl@linux.com>
cc: Joonsoo Kim <js1304@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] slub: fix a memory leak in get_partial_node()
In-Reply-To: <alpine.DEB.2.00.1205151527150.11923@router.home>
Message-ID: <alpine.LFD.2.02.1205160935340.1763@tux.localdomain>
References: <1337108498-4104-1-git-send-email-js1304@gmail.com> <alpine.DEB.2.00.1205151527150.11923@router.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<On Tue, 15 May 2012, Christoph Lameter wrote:

> On Wed, 16 May 2012, Joonsoo Kim wrote:
> 
> > In the case which is below,
> >
> > 1. acquire slab for cpu partial list
> > 2. free object to it by remote cpu
> > 3. page->freelist = t
> >
> > then memory leak is occurred.
> 
> Hmmm... Ok so we cannot assign page->freelist in get_partial_node() for
> the cpu partial slabs. It must be done in the cmpxchg transition.
> 
> Acked-by: Christoph Lameter <cl@linux.com>

Joonsoo, can you please fix up the stable submission format, add 
Christoph's ACK and resend?

			Pekka
