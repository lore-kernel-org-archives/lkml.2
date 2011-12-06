Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab1LFBUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:20:18 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49594 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab1LFBUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:20:17 -0500
Date: Tue, 6 Dec 2011 05:20:12 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/5] power: sbs-battery: rename internals to new name
Message-ID: <20111206012012.GA3065@oksana.dev.rtsoft.ru>
References: <1323129487-24859-1-git-send-email-rklein@nvidia.com>
 <1323129487-24859-2-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1323129487-24859-2-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 03:58:04PM -0800, Rhyland Klein wrote:
[...]
> -static const struct i2c_device_id bq20z75_id[] = {
> -	{ "bq20z75", 0 },
> +static const struct i2c_device_id sbs_id[] = {
> +	{ "sbs-battery", 0 },

You have to leave "bq20z75" here as is, and add "sbs-battery" as an
additional device id.

The reason is that older device trees might already have compatible
= "bq20z75", without specifying "sbs-battery".

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
