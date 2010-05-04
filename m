Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab0EDJtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 05:49:07 -0400
Received: from mail-ew0-f222.google.com ([209.85.219.222]:34249 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab0EDJtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 05:49:05 -0400
Message-ID: <4BDFED62.3050800@ru.mvista.com>
Date: Tue, 04 May 2010 13:48:18 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Dinh.Nguyen@freescale.com
CC: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
       linux@arm.linux.org.uk, s.hauer@pengutronix.de,
       grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
       daniel@caiaq.de, bryan.wu@canonical.com, valentin.longchamp@epfl.ch
Subject: Re: [PATCH 2.6.34-rc6] mxc: gadget: Fix bitfield for calculating
 maximum	packet size
References: <1272915663-21562-1-git-send-email-Dinh.Nguyen@freescale.com>
In-Reply-To: <1272915663-21562-1-git-send-email-Dinh.Nguyen@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Dinh.Nguyen@freescale.com wrote:

> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
>
> The max packet length bit mask used for isochronous endpoints
> should be 0x7FF instead of 0x8FF. 0x8FF will actually clear
> higher-order bits in the max packet length field.
>
> This patch applies to 2.6.34-rc6.
>
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>

   You should send this to the linux-usb mailing list.

WBR, Sergei

