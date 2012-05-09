Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760361Ab2EIRGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:06:10 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:58878 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757560Ab2EIRGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:06:09 -0400
Date: Wed, 9 May 2012 10:06:03 -0700
From: Tejun Heo <tj@kernel.org>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: Fix rollback in pcpu_embed_first_chunk()
Message-ID: <20120509170603.GA24636@google.com>
References: <20120509143948.4ba4e949@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509143948.4ba4e949@br98xy6r>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 09, 2012 at 02:39:48PM +0200, Michael Holzheu wrote:
> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> Subject: percpu: Fix rollback in pcpu_embed_first_chunk()
> 
> The "out_free_areas" rollback in pcpu_embed_first_chunk calls the
> free_fn() function for all elements in area[]. This is not correct
> because not all elements have been allocated.
> 
> To fix this we call free_fn() only for allocated elements.

There's already a pending fix which fixes this and another more
serious problem, which I forgot to push.  I'll push it out today.

  http://article.gmane.org/gmane.linux.kernel/1288808

Thanks.

-- 
tejun
