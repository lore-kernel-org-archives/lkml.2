Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540Ab2AFCRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 21:17:12 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59995 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762Ab2AFCRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 21:17:10 -0500
Date: Fri, 6 Jan 2012 06:17:05 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Vasily Khoruzhick <anarsoul@gmail.com>, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] s3c_adc_battery: average over more than one adc sample
Message-ID: <20120106021705.GC21540@oksana.dev.rtsoft.ru>
References: <201112291252.08563.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201112291252.08563.heiko@sntech.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 12:52:07PM +0100, Heiko Stübner wrote:
> Some sources for adc battery information provide only inaccurate results
> where the read value differs from the real value with positive and negative
> offsets. For such sources it can be more accurate to collect two or more
> value sample and use the average of all collected values.
> 
> This patch adds pdata options volt_samples, current_samples and
> backup_volt_samples to specifiy the number of samples to collect,
> reads the specified number of samples and calculates the average of those.
> For unset sample-number-values a default of 1 is assumed.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
