Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab2LQG7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 01:59:30 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:42213 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2LQG73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 01:59:29 -0500
Date: Sun, 16 Dec 2012 22:56:03 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] charger-manager: Fix bug related to checking
 fully charged state of battery
Message-ID: <20121217065603.GB9027@lizard.gateway.2wire.net>
References: <1353570826-19404-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1353570826-19404-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 04:53:46PM +0900, Chanwoo Choi wrote:
> This patch fix bug related to checking fully charged state of battery
> when charger-manager call is_full_charged() function. After reading
> property of charger/fuel-gauge through power_supply API, val.intval is
> more than 1. So, is_full_charged() function always return true. If true,
> battery means fully charged state.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---

Applied, thanks!
