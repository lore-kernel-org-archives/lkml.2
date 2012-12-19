Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab2LSW0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 17:26:35 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:46446 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab2LSW01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 17:26:27 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 00/21] gpio: ab8500: Bring AB8500 back to life
To: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Date: Wed, 19 Dec 2012 22:26:23 +0000
Message-Id: <20121219222623.3182B3E0AD6@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2012 16:19:18 +0000, Lee Jones <lee.jones@linaro.org> wrote:
> The ab8500 GPIO driver is currently 'BROKEN', due to a lack of
> updates and recent frame-work adoption. This patch-set aims to
> bring the driver back to life so we may make use of it again.
> 
> This first stage is to bring it into line with ST-Ericsson's
> internal track, which has been keeping up-to-date. After these
> patches have been accepted I will then overhaul the driver to
> use the most recent APIs and frame-works, such as pinctrl and
> Device Tree.
> 
> Please give these patches an easy ride. I know they're not
> perfect, but they do provide a great base on with I can form
> the overhaul. Thanks for your understanding.

Since it's already broken, I'll probably pick up the majority of these
as long as they make the world better. I'll reply to each in turn.

g.

