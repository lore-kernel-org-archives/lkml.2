Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab2ISKNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 06:13:20 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51048 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab2ISKNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 06:13:17 -0400
MIME-Version: 1.0
In-Reply-To: <1348122889-28271-3-git-send-email-panto@antoniou-consulting.com>
References: <50596F8F.60506@ti.com>
	<1348122889-28271-1-git-send-email-panto@antoniou-consulting.com>
	<1348122889-28271-3-git-send-email-panto@antoniou-consulting.com>
Date: Wed, 19 Sep 2012 15:43:16 +0530
Message-ID: <CAM=Q2cuk83QNWcir7LWx=0+8rP4u97ei94ZB2XN=T9sFQ7v6fQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] OMAP i2c: pinctrl-ify i2c-omap.c
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Shubhrajyoti D <shubhrajyoti@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 12:04 PM, Pantelis Antoniou
<panto@antoniou-consulting.com> wrote:
> Add support for pinctrl mux settings in the OMAP I2C driver.
> If no such pinctl bindings are found a warning message is printed.
>
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
looks good
Acked-by: Shubhrajyoti D <shubhrajyoti@ti.com>
