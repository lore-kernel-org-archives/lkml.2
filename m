Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab1HXUXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 16:23:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53972 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab1HXUXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 16:23:35 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 3.0.1: irq/48-eth1-rx-: page allocation failure: order:1, mode:0x20
Date: Wed, 24 Aug 2011 22:23:25 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc4; KDE/4.6.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
References: <alpine.DEB.2.02.1108180610310.11234@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1108180610310.11234@p34.internal.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108242223.25628.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 18 sierpnia 2011 o 12:11:35 Justin Piszcz wrote:
> Hello,
> 
> Mem:   8194732k total,  8061488k used,   133244k free,  3211684k buffers
> Swap: 16787772k total,        0k used, 16787772k free,  3938768k cached
> 
> Any thoughts on what caused the error below?
> No swap is used.
> 

It's regression?

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
