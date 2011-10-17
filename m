Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab1JQJjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 05:39:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36865 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893Ab1JQJjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 05:39:19 -0400
Date: Mon, 17 Oct 2011 10:39:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, zdevai@gmail.com
Subject: Re: [PATCH] staging:iio:proof of concept in kernel interface.
Message-ID: <20111017093913.GB3042@opensource.wolfsonmicro.com>
References: <1318333383-17663-1-git-send-email-jic23@cam.ac.uk>
 <1318333383-17663-2-git-send-email-jic23@cam.ac.uk>
 <20111013143224.GO1098@sirena.org.uk>
 <4E96F9AC.9000001@cam.ac.uk>
 <20111013204410.GA17160@sirena.org.uk>
 <4E985C60.9020308@cam.ac.uk>
 <CAKnu2MrUkY2upFh5d6GGTNUr-=r_JKcxh5OQNV63bdOCa4F+zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKnu2MrUkY2upFh5d6GGTNUr-=r_JKcxh5OQNV63bdOCa4F+zg@mail.gmail.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 16, 2011 at 08:45:06PM +0200, Linus Walleij wrote:

> Then this API feels comfortable:

> struct adc *adc_get(struct device *dev, const char *channel);
> void adc_put(struct adc *adc);
> int adc_read_raw(struct adc *adc, int *val);

> We can then add adc_read_voltage(), adc_read_temperature(), adc_read_foo() ...

That should work for pretty much all of the AUXADCs.
