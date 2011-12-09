Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751136Ab1LIGjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 01:39:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47176 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784Ab1LIGjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 01:39:19 -0500
Date: Fri, 9 Dec 2011 14:39:13 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        dg77.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: add irq domain support for max8997 interrupts
Message-ID: <20111209063912.GG26952@opensource.wolfsonmicro.com>
References: <1323361659-11835-1-git-send-email-thomas.abraham@linaro.org>
 <1323361659-11835-2-git-send-email-thomas.abraham@linaro.org>
 <20111209044109.GB26952@opensource.wolfsonmicro.com>
 <CAJuYYwRicSWO=wCmBH5RWcBLX3uhpyxS2wojUS3ZAH9tN=R1Kg@mail.gmail.com>
 <20111209060249.GD26952@opensource.wolfsonmicro.com>
 <CAJuYYwSCuu8U2rF3RGAnczXgbh4Px7hMwUhHr=xrhPZ1jEs5DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuYYwSCuu8U2rF3RGAnczXgbh4Px7hMwUhHr=xrhPZ1jEs5DA@mail.gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 12:00:07PM +0530, Thomas Abraham wrote:

> If these gpio's are connected to the host system, and host system sets
> up gpio interrupt notification for these gpio lines, the linux irq
> number for the gpio interrupt would belong to the irq domain of the
> host interrupt controller (gic irq domain in case of exynos).
> Consumers of this interrupt would use the gpio interrupt independent
> of the max8997 irq domain. So irq_base can be maintained private to
> the max8997 mfd driver and its sub-block drivers.

How would you provide this interrupt to the device using it in a non-DT
systemm without passing the irq_base into the device as platform data?
