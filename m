Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab2IUFLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 01:11:21 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35286 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab2IUFLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 01:11:17 -0400
Date: Thu, 20 Sep 2012 22:08:38 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] charger-manager: Support limit of maximum possible
 duration for charging/discharging
Message-ID: <20120921050837.GA927@lizard>
References: <1345536417-25948-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1345536417-25948-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 05:06:57PM +0900, Chanwoo Choi wrote:
> This patch check maximum possible duration of charging/discharging.
> 
> If whole charging duration exceed 'desc->charging_max_duration_ms',
> cm stop charging to prevent overcharge/overheat. And if discharging
> duration exceed, charger cable is attached, after full-batt,
> cm start charging to maintain fully charged state for battery.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---

Applied, thanks!

But fyi:

[...]
> +	if (!desc->charging_max_duration_ms
> +		&& !desc->discharging_max_duration_ms)

&& should have been on the previous line, plus the second line
should have been indented with one more tab. I fixed it up.

[...]
> +	if (!desc->charging_max_duration_ms
> +		|| !desc->discharging_max_duration_ms) {

Ditto.

> +		dev_info(&pdev->dev, "Cannot limit charging duration"
> +				" checking mechanism to prevent "
> +				" overcharge/overheat and control"

Thanks,
Anton.
