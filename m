Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab1GJU4L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 16:56:11 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19090 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab1GJU4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 16:56:06 -0400
Date: Sun, 10 Jul 2011 22:56:05 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
cc: teigland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: kmallocs with swapped parameters in fs/dlm/lock.c
In-Reply-To: <20110710003032.GA19951@gallifrey>
Message-ID: <alpine.LNX.2.00.1107102254370.2818@swampdragon.chaosbits.net>
References: <20110710003032.GA19951@gallifrey>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jul 2011, Dr. David Alan Gilbert wrote:

> Hi David,
>   Sparse spotted a couple of places in fs/dlm/lock.c where the size/flags
> parameters to kmalloc got swapped:
> 
[...]
> Jesper:
>   I noticed in your patch:
> https://lkml.org/lkml/2011/7/2/90
> 
> where you had done a kmalloc->kzalloc transform you kept the swap.
> 
> This looks like new code in 3.0rc so I don't think you could quite
> call it a regression, but it should probably be fixed fairly quickly
> I guess.
> 
D'oh, I completely overlooked that.
Thank you for noticing and letting me know. I've just submitted an updated 
patch.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

