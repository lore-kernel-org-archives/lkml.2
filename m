Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab1DGV7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 17:59:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755043Ab1DGV7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 17:59:11 -0400
Date: Thu, 7 Apr 2011 14:58:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel@wildgooses.com
Cc: rpurdie@rpsys.net, const@mimas.ru, daniel@caiaq.de, a.zummo@towertech.it,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: New PCEngines Alix LED driver using gpio
 interface
Message-Id: <20110407145836.3cde7699.akpm@linux-foundation.org>
In-Reply-To: <1299430285-13189-1-git-send-email-kernel@wildgooses.com>
References: <1299430285-13189-1-git-send-email-kernel@wildgooses.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  6 Mar 2011 16:51:25 +0000
kernel@wildgooses.com wrote:

> From: Ed Wildgoose <kernel@wildgooses.com>
> 
> This new driver replaces the old PCEngines Alix 2/3 LED driver with
> a new driver that controls the LEDs through the leds-gpio driver.
> The old driver accessed GPIOs directly, which created a conflict 
> and prevented also loading the cs5535-gio driver to read other
> GPIOs on the Alix board. With this new driver, both are loaded
> and therefore it's possible to access both the LEDs and onboard GPIOs 
> 
> This driver is based on leds-net5501.c 
> by: Alessandro Zummo <a.zummo@towertech.it>
> Additionally it relies on parts of the patch: 7f131cf3ed
> by: Daniel Mack <daniel@caiaq.de> to perform detection of the Alix board

As far as I can tell from looking at it, this driver maintains all the
same interfaces and behaviour as the old version.  Am I right?

