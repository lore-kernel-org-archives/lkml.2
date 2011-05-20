Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab1ETMsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 08:48:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:59030 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab1ETMsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 08:48:08 -0400
Date: Fri, 20 May 2011 14:48:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.39: crash w/threadirqs option enabled
In-Reply-To: <alpine.DEB.2.02.1105200405210.24033@p34.internal.lan>
Message-ID: <alpine.LFD.2.02.1105201445300.3078@ionos>
References: <alpine.DEB.2.02.1105200405210.24033@p34.internal.lan>
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

> Hi,
> 
> I tried this in 2.6.39 and experienced crashes for the first time, when
> using: threadirqs
> 
> user     pts/1                         Fri May 20 04:31   still logged in
> reboot   system boot  2.6.39           Fri May 20 04:28 - 04:36  (00:07) user
> pts/2                         Thu May 19 20:01 - down   (08:24) reboot
> system boot  2.6.39           Thu May 19 20:01 - 04:26  (08:25) user
> pts/28                        Thu May 19 15:57 - crash  (04:03)
> 
> Not sure I can give any useful output as there is nothing in the logs, even
> with netconsole enabled, no useful output was produced.

Hmm. Machine lacks serial console, right? Can you send me your .config
please?

Thanks,

	tglx
