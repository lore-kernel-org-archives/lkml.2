Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab1LFBVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:21:21 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5722 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab1LFBVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:21:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 05 Dec 2011 17:21:16 -0800
Subject: Re: [PATCH 2/5] power: sbs-battery: rename internals to new name
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
In-Reply-To: <20111206012012.GA3065@oksana.dev.rtsoft.ru>
References: <1323129487-24859-1-git-send-email-rklein@nvidia.com>
	 <1323129487-24859-2-git-send-email-rklein@nvidia.com>
	 <20111206012012.GA3065@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Dec 2011 17:20:10 -0800
Message-ID: <1323134410.24760.1.camel@rklein-linux2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 17:20 -0800, Anton Vorontsov wrote:
> On Mon, Dec 05, 2011 at 03:58:04PM -0800, Rhyland Klein wrote:
> [...]
> > -static const struct i2c_device_id bq20z75_id[] = {
> > -	{ "bq20z75", 0 },
> > +static const struct i2c_device_id sbs_id[] = {
> > +	{ "sbs-battery", 0 },
> 
> You have to leave "bq20z75" here as is, and add "sbs-battery" as an
> additional device id.
> 
> The reason is that older device trees might already have compatible
> = "bq20z75", without specifying "sbs-battery".
> 
> Thanks!
> 

Good thought! I had thought about that at some point but apparently not
when actually working on the patch. Will do in v2.

-rhyland

