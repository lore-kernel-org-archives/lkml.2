Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810Ab1ETNaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:30:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:37859 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933693Ab1ETNaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:30:03 -0400
Date: Fri, 20 May 2011 15:30:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.39: crash w/threadirqs option enabled
In-Reply-To: <alpine.DEB.2.02.1105200850080.19553@p34.internal.lan>
Message-ID: <alpine.LFD.2.02.1105201528500.3078@ionos>
References: <alpine.DEB.2.02.1105200405210.24033@p34.internal.lan> <alpine.LFD.2.02.1105201445300.3078@ionos> <alpine.DEB.2.02.1105200850080.19553@p34.internal.lan>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011, Justin Piszcz wrote:
> On Fri, 20 May 2011, Thomas Gleixner wrote:
> 
> Correct, no serial port or header, config:
> http://home.comcast.net/~jpiszcz/20110520/config-2.6.39-3.txt

Does it crash right away or just when doing something particular? Is
the box fully dead after the crash ?

Thanks,

	tglx
