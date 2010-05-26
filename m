Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933951Ab0EZSfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:35:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:47190 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab0EZSfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 14:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VUGcbXKn/Sbwr9/bOOTxWL/vkkacD0dkRouRwG+ebLza9Ac75H/b15ZTt6/2PKLsq2
         5EppK+Cypaclpi+uFfI8KFtxXAkSwj3e1JoSq+7Q3c/GOPFnVWcn54Z2ex2M6uxK3TB/
         xPI4SvA+xIsp5IMBcqFOE+G/Wd5Y8ef00PYBQ=
Date: Wed, 26 May 2010 21:35:01 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Sebastien JAN <s-jan@ti.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] Add missing extern to heap_free declaration
Message-ID: <20100526183501.GA14969@x200.telecom.by>
References: <1274898499-32497-1-git-send-email-s-jan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274898499-32497-1-git-send-email-s-jan@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 08:28:19PM +0200, Sebastien JAN wrote:
> heap_free() function is defined in lib/prio_heap.c

> --- a/include/linux/prio_heap.h
> +++ b/include/linux/prio_heap.h
> -void heap_free(struct ptr_heap *heap);
> +extern void heap_free(struct ptr_heap *heap);

This is totally unneeded.

In fact, externless prototypes are better.
