Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab0EZSjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:39:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37395 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab0EZSjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 14:39:16 -0400
From: Sebastien Jan <s-jan@ti.com>
Organization: Texas Instruments
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Add missing extern to heap_free declaration
Date: Wed, 26 May 2010 20:39:09 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-generic; KDE/4.3.2; i686; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
References: <1274898499-32497-1-git-send-email-s-jan@ti.com> <20100526183501.GA14969@x200.telecom.by>
In-Reply-To: <20100526183501.GA14969@x200.telecom.by>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005262039.10077.s-jan@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 May 2010 20:35:01 Alexey Dobriyan wrote:
> On Wed, May 26, 2010 at 08:28:19PM +0200, Sebastien JAN wrote:
> > heap_free() function is defined in lib/prio_heap.c
> >
> > --- a/include/linux/prio_heap.h
> > +++ b/include/linux/prio_heap.h
> > -void heap_free(struct ptr_heap *heap);
> > +extern void heap_free(struct ptr_heap *heap);
> 
> This is totally unneeded.
> 
> In fact, externless prototypes are better.
> 

The attempt was to have a unified way of declaring the functions in this
file since the other functions have the 'export'.
