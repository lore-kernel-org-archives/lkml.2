Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab0GMOSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 10:18:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59792 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751449Ab0GMOSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 10:18:30 -0400
Date: Tue, 13 Jul 2010 15:18:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: lrg@slimlogic.co.uk, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        STEricsson_nomadik_linux@list.st.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH v2 2/2] ux500: add ab8500-regulators machine specific
 data
Message-ID: <20100713141828.GB24260@rakim.wolfsonmicro.main>
References: <1279030173-3086-1-git-send-email-sundar.iyer@stericsson.com>
 <1279030173-3086-2-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279030173-3086-2-git-send-email-sundar.iyer@stericsson.com>
X-Cookie: My EARS are GONE!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 07:39:33PM +0530, Sundar Iyer wrote:

> +static struct regulator_consumer_supply ab8500_vaux1_consumers[] = {
> +	{ .supply = "vaux1", },
> +};

It is extremely disappointing to see you reposting this without engaging
with my previous review at all.
