Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab0DPDWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 23:22:06 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:37523 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423Ab0DPDWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 23:22:04 -0400
Date: Fri, 16 Apr 2010 13:21:52 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Joe Perches <joe@perches.com>
cc: "David S. Miller" <davem@davemloft.net>,
       Paul Gortmaker <p_gortmaker@yahoo.com>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: another cleanup patch gone wrong
In-Reply-To: <1271387506.2298.17.camel@Joe-Laptop.home>
Message-ID: <alpine.OSX.2.00.1004161318470.271@localhost>
References: <alpine.OSX.2.00.1004161214270.271@localhost> <1271387506.2298.17.camel@Joe-Laptop.home>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 15 Apr 2010, Joe Perches wrote:

> > Why the macro? You only used it once.
> 
> It's used embedded in the pr_<level> functions.
> It's used more than once.
> 
> > The pr_xxx naming convention belongs to a kernel-wide include file. Is it 
> > really a good idea to start repurposing it in .c files?
> 
> It's in kernel.h, and yes, it is.
> http://lkml.org/lkml/2008/11/12/297

My mistake.

Finn
