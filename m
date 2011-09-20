Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab1ITVnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 17:43:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:46525 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab1ITVnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 17:43:11 -0400
Message-ID: <4E7908EC.9080802@linutronix.de>
Date: Tue, 20 Sep 2011 23:43:08 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Icedove/3.1.13
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] irq/irqdomain: change bail out condition for irq_domain_add()
References: <1316554589-24393-1-git-send-email-bigeasy@linutronix.de> <alpine.LFD.2.02.1109202340060.2723@ionos>
In-Reply-To: <alpine.LFD.2.02.1109202340060.2723@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 11:41 PM, Thomas Gleixner wrote:
> I've already queued a similar fix in tip/irq/urgent

It is not in master branch of the tip tree.

> Thanks,
>
> 	tglx

Sebastian
