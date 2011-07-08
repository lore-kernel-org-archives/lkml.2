Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab1GHNMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 09:12:05 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:39590 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab1GHNMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 09:12:01 -0400
Date: Fri, 8 Jul 2011 17:11:16 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Donggeun Kim <dg77.kim@samsung.com>, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH] power_supply: Add charger driver for MAX8997/8966
Message-ID: <20110708131115.GE29056@oksana.dev.rtsoft.ru>
References: <1308739206-7802-1-git-send-email-dg77.kim@samsung.com>
 <20110704140937.GD3021@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110704140937.GD3021@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 04:09:37PM +0200, Samuel Ortiz wrote:
> On Wed, Jun 22, 2011 at 07:40:06PM +0900, Donggeun Kim wrote:
> > MAX8997/8966 chip is a multi-function device which includes
> > PMIC, RTC, Fuel Gauge, MUIC, Haptic, Flash control, and
> > Battery charging control.
> > The driver for it is located at drivers/mfd.
> > 
> > This patch supports battery charging control of MAX8997/8966 chip and
> > provides power supply class information to userspace.
> > 
> > Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
> > Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> > Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
> In case Anton needs it, for the MFD part:
> 
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
