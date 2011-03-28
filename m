Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab1C1XxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 19:53:15 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:8346 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1C1XxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 19:53:14 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1301356393!18131124!1
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.99]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ryan Mallon <ryan@bluewatersys.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux kernel <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 28 Mar 2011 18:53:12 -0500
Subject: RE: [PATCH] EP93xx: Remove ep93xx_gpio_dbg_show function
Thread-Topic: [PATCH] EP93xx: Remove ep93xx_gpio_dbg_show function
Thread-Index: AcvtnER+zfIH1ImjRlqohSjLoIgLgQABuW9g
Message-ID: <0D753D10438DA54287A00B027084269764D19A811F@AUSP01VMBX24.collaborationhost.net>
References: <4D9113AA.20404@bluewatersys.com>
In-Reply-To: <4D9113AA.20404@bluewatersys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 28, 2011 4:03 PM, Ryan Mallon wrote:
>
> Hartley pointed out that the patch I posted to remove the irq internals
> fiddling from ep93xx_gpio_dbg_show does not function as expected. It
> will print [interrupt] beside all pins which are capable of being
> interrupts, not just those which are currently configured as interrupts.
>
> The best solution is just to remove the custom ep93xx gpio debugfs
> function all together. The generic gpiolib one is good enough.
>
> Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
