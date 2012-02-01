Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab2BAWnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:43:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679Ab2BAWnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:43:42 -0500
Date: Wed, 1 Feb 2012 14:43:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: William Irwin <wli@holomorphy.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] hugetlbfs: fix hugetlb_get_unmapped_area
Message-Id: <20120201144340.01b3d050.akpm@linux-foundation.org>
In-Reply-To: <4F2784BE.9090600@linux.vnet.ibm.com>
References: <4F101904.8090405@linux.vnet.ibm.com>
	<4F2784BE.9090600@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 14:05:50 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> On 01/13/2012 07:44 PM, Xiao Guangrong wrote:
> 
> > Using/updating cached_hole_size and free_area_cache properly to speedup
> > find free region
> > 
> 
> 
> Ping...???

I'd saved the patches away, hoping that someone who works on hugetlb
would comment.  They didn't.  We haven't heard from wli in a long time.
