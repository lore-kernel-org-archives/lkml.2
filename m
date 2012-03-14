Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761604Ab2CNWPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 18:15:06 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40433 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761579Ab2CNWPE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 18:15:04 -0400
MIME-Version: 1.0
In-Reply-To: <1331757790-10583-7-git-send-email-marc@cpdesign.com.au>
References: <1331757790-10583-1-git-send-email-marc@cpdesign.com.au>
	<1331757790-10583-7-git-send-email-marc@cpdesign.com.au>
Date: Wed, 14 Mar 2012 19:15:01 -0300
Message-ID: <CAOMZO5BVObpszMd4_dDr3NHw9-oXh9wY_T48UA2vMWozdUyukw@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] mfd: mc13xxx: Add i2c driver
From: Fabio Estevam <festevam@gmail.com>
To: Marc Reilly <marc@cpdesign.com.au>
Cc: sameo@linux.intel.com, linux-arm-kernel@lists.infradead.org,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        spi-devel-general@lists.sourceforge.net, oskar@scara.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On Wed, Mar 14, 2012 at 5:43 PM, Marc Reilly <marc@cpdesign.com.au> wrote:

> +
> +static const struct i2c_device_id mc13xxx_i2c_device_id[] = {
> +       {
> +               .name = "mc13783",
> +               .driver_data = MC13XXX_ID_MC13783

mc13783 does not have i2c interface.
