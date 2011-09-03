Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab1ICItK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 04:49:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44909 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab1ICItH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 04:49:07 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 3.1.0-rc2: irq/112-eth0-Tx: page allocation failure: (w/frame pointers enabled)
Date: Sat, 3 Sep 2011 10:49:00 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc4; KDE/4.6.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
References: <alpine.DEB.2.02.1108260802590.14539@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1108260802590.14539@p34.internal.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201109031049.00728.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On piątek, 26 sierpnia 2011 o 14:14:12 Justin Piszcz wrote:
> Hello,
> 
> Why does this occur on a machine with 48GB of memory (used mainly as a
> router) and backup server, is it a kernel bug?
> 

It's regression? Any older kernel works OK?

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
