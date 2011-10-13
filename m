Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab1JMUMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 16:12:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:43646 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1JMUMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 16:12:43 -0400
Date: Thu, 13 Oct 2011 22:12:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
cc: Rob Herring <robherring2@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] irq: support domains with non-zero hwirq base
In-Reply-To: <20111013193347.GB18574@ponder.secretlab.ca>
Message-ID: <alpine.LFD.2.02.1110132212120.3240@ionos>
References: <20111004233953.GE3009@ponder.secretlab.ca> <1317783380-773-1-git-send-email-robherring2@gmail.com> <4E944242.10606@gmail.com> <20111013193347.GB18574@ponder.secretlab.ca>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, Grant Likely wrote:

> Thomas, any objection to this patch?  It's entirely contained within
> the irq_domain stuff, so it is pretty well isolated.
> 
> It can be merged via arm-soc since it is depended on by some of the
> irq work.
 
Acked-by-me
