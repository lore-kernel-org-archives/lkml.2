Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0ESBuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:50:20 -0400
Received: from trinity.fluff.org ([89.16.178.74]:46191 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab0ESBuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:50:17 -0400
Date: Wed, 19 May 2010 02:50:00 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: InKi Dae <inki.dae@samsung.com>
Cc: akpm@linux-foundation.org, ben-linux@fluff.org,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com
Subject: Re: [PATCH] s3c-fb:  enable fimd driver for s5pv210.
Message-ID: <20100519014959.GD4720@trinity.fluff.org>
References: <4BF29B5C.2050202@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF29B5C.2050202@samsung.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 10:51:24PM +0900, InKi Dae wrote:
> I'm sorry for being late.
> 
> this patch is for s5pv210.
> to support s5pv210, CH_ENABLE bit of SHADOW register should be enabled to enable window layer on s5pv210.

I'd like to hold this until the chnages for multi-hardware
support and header file cleanup are done.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

