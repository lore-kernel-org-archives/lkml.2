Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab0INToz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:44:55 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:32018 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab0INTox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:44:53 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz1432N98dNzz1202hzzz2dh2a8h62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <4C8FD0B0.70500@freescale.com>
Date: Tue, 14 Sep 2010 14:44:48 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/2.0.6-1.fc13 SeaMonkey/2.0.6
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        kumar.gala@freescale.com, amit.shah@redhat.com
Subject: Re: [PATCH] hvc_console: fix dropping of characters when output byte
 channel is full
References: <1282329921-24394-1-git-send-email-timur@freescale.com>	<20100914121721.c8671ed8.akpm@linux-foundation.org>	<20100914204410.71942cdc@lxorguk.ukuu.org.uk>	<4C8FCC2E.1020107@freescale.com> <20100914205246.0e35c9af@lxorguk.ukuu.org.uk>
In-Reply-To: <20100914205246.0e35c9af@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Sep 2010 19:44:49.0225 (UTC) FILETIME=[4AA8E390:01CB5445]
X-Reverse-DNS: de01egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> If you want to make that change then I guess you need to audit every
> other hvc driver first.
> 
> But I never understood the point of the hvc layer anyway 8)

We've come to the same conclusion here.  I think we're just going to drop
the hvc layer and make the driver a standard console driver.

-- 
Timur Tabi
Linux kernel developer at Freescale

