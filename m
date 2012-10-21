Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab2JUETK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 00:19:10 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59508 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab2JUETI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 00:19:08 -0400
Date: Sat, 20 Oct 2012 21:19:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, rmallon@gmail.com
Subject: Re: [PATCH 2/5 v6] gpio: Add sysfs support to block GPIO API
Message-ID: <20121021041930.GA7027@kroah.com>
References: <1350728508-22508-1-git-send-email-stigge@antcom.de>
 <1350728508-22508-3-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350728508-22508-3-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2012 at 12:21:45PM +0200, Roland Stigge wrote:
> This patch adds sysfs support to the block GPIO API.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Thanks for the updates, looks good to me:

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
