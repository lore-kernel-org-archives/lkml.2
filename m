Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab2LQLQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 06:16:58 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60825 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab2LQLQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 06:16:56 -0500
Date: Mon, 17 Dec 2012 03:16:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Con Kolivas <kernel@kolivas.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] 3.7-ck1, BFS 426 for linux-3.7
In-Reply-To: <7369728.ymAnBsBeai@hex>
Message-ID: <alpine.DEB.2.00.1212170314370.21139@chino.kir.corp.google.com>
References: <7369728.ymAnBsBeai@hex>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Dec 2012, Con Kolivas wrote:

> These are patches designed to improve system responsiveness and
> interactivity with specific emphasis on the desktop, but suitable to
> any commodity hardware workload.
> 
> Apply to 3.7.x:
> -ck-ckhttp://ck.kolivas.org/patches/3.0/3.7/3.71/patch-3.71.bz2
> or
> -ck-ckhttp://ck.kolivas.org/patches/3.0/3.7/3.71/patch-3.71.lrz
> 
> Broken out tarball:
> -ck-ckhttp://ck.kolivas.org/patches/3.0/3.7/3.71/3.71-broken-out.tar.bz2
> or
> -ck-ckhttp://ck.kolivas.org/patches/3.0/3.7/3.71/3.71-broken-out.tar.lrz
> 
> Discrete patches:
> -ckhttp://ck.kolivas.org/patches/3.0/3.7/3.71/patches/
> 
> Latest BFS by itself:
> http://ck.kolivas.org/patches/bfs/3.0/3.7/3.7-sched-bfs-426.patch
> 
> Web:
> http://kernel.kolivas.org
> 
> Code blog when I feel like it:
> http://ck-hack.blogspot.com/
> 

One thing that caught my eye here was the hardwiring of SLUB as the slab 
allocator and not making the others configurable.  I looked around a 
little bit on your website and it says that's because of kernel crashes 
with SLAB and SLOB and that peaked my interest even more.  Could you 
describe the issues that you saw that makes those slab allocators have 
trouble with this type of schedular design?

Thanks.
