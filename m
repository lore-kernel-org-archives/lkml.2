Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab2DEIO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 04:14:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:34016 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab2DEIOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 04:14:55 -0400
Date: Thu, 5 Apr 2012 10:14:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] irq: Kill pointless irqd_to_hw export
In-Reply-To: <1333464796-21861-1-git-send-email-grant.likely@secretlab.ca>
Message-ID: <alpine.LFD.2.02.1204051014310.2542@ionos>
References: <1333464796-21861-1-git-send-email-grant.likely@secretlab.ca>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2012, Grant Likely wrote:

> It makes no sense to export this trivial function.  Make it a static inline
> instead.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Acked-by: Thomas Gleixner <tglx@linutronix.de>
