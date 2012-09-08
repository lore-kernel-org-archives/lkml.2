Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab2IHIhd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 04:37:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53852 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2IHIha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 04:37:30 -0400
Date: Sat, 8 Sep 2012 01:34:41 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: anish kumar <anish198519851985@gmail.com>
Cc: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org, lars@metafoo.de
Subject: Re: [PATCH] [RFC]power: battery: Generic battery driver using IIO
Message-ID: <20120908083441.GA21856@lizard>
References: <1346600372-3284-1-git-send-email-anish198519851985@gmail.com>
 <5049A7B8.506@kernel.org>
 <1347088218.5051.152.camel@anish-Inspiron-N5050>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1347088218.5051.152.camel@anish-Inspiron-N5050>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2012 at 12:40:18PM +0530, anish kumar wrote:
[...]
> > > Signed-off-by: anish kumar <anish198519851985@gmail.com>
> > So what happened in 1985?
> Was hurrying to get an email id :)

I so much understand... ;-)

Much thanks to Lars-Peter and Jonathan, saved me a lot of time reviewing
the driver.

Anish, the idea of generic IIO driver looks great, I'm impatiently
waiting for a new revision!

One suggestion: the file name says generic-battery, the code sometimes
uses generic_adc_battery sometimes generic_battery. I'd suggest being
consistent, and stick to one naming scheme. I'd prefer
generic_adc_battery.

Thanks!

Anton.
