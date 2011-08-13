Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab1HMNjA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 09:39:00 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:54780 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751314Ab1HMNi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 09:38:59 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/jXAEvxInjAD4hoKSJSgBmwXx7mPs40OKgs/as3U
	F+BdeNLcmpQThN
From: Peter =?utf-8?q?H=C3=BCwe?= <PeterHuewe@gmx.de>
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] [ARM] Orion: gpio: add missing include of linux/types.h
Date: Sat, 13 Aug 2011 15:38:55 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39.3; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Lennert Buytenhek <kernel@wantstofly.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
References: <1313137556.24918.2.camel@phoenix>
In-Reply-To: <1313137556.24918.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108131538.55741.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 12 August 2011, 10:25:56 schrieb Axel Lin:
> This patch adds missing include of linux/types.h to fix below build error.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

I was about to send the same patch ;)

Reviewed-by: Peter Huewe <peterhuewe@gmx.de>

