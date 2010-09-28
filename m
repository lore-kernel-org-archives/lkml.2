Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab0I1Qwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:52:39 -0400
Received: from mail.perches.com ([173.55.12.10]:2494 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756700Ab0I1Qwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:52:37 -0400
Subject: Re: [PATCH] Add ALS drivers for the apds9802als
From: Joe Perches <joe@perches.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100928155649.17671.61810.stgit@localhost.localdomain>
References: <20100928155649.17671.61810.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 09:52:35 -0700
Message-ID: <1285692755.1866.66.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 16:56 +0100, Alan Cox wrote:
>  drivers/misc/apds9802als.c |  308 ++++++++++++++++++++++++++++++++++++++++++++
[]
> +static int  apds9802als_probe(struct i2c_client *client,
> +					const struct i2c_device_id *id)
> +{
> +	int res;
> +	struct als_data *data;
> +
> +	data = kzalloc(sizeof(struct als_data), GFP_KERNEL);
> +	if (data == NULL) {
> +		dev_err(&client->dev, "Memory allocation failed");

missing newline.


