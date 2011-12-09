Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab1LIGC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 01:02:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42268 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941Ab1LIGC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 01:02:56 -0500
Date: Fri, 9 Dec 2011 14:02:50 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        dg77.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: add irq domain support for max8997 interrupts
Message-ID: <20111209060249.GD26952@opensource.wolfsonmicro.com>
References: <1323361659-11835-1-git-send-email-thomas.abraham@linaro.org>
 <1323361659-11835-2-git-send-email-thomas.abraham@linaro.org>
 <20111209044109.GB26952@opensource.wolfsonmicro.com>
 <CAJuYYwRicSWO=wCmBH5RWcBLX3uhpyxS2wojUS3ZAH9tN=R1Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuYYwRicSWO=wCmBH5RWcBLX3uhpyxS2wojUS3ZAH9tN=R1Kg@mail.gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 10:55:10AM +0530, Thomas Abraham wrote:
> On 9 December 2011 10:11, Mark Brown

> > Removing irq_base from platform data isn't going to be helpful for
> > anyone using the driver on non-DT platforms as it's going to make it
> > impossible to find the interrupts.

> All the consumers of the max8997 interrupts are the drivers for the
> sub-blocks of max8997. These drivers have access to 'irq_domain'
> member of 'struct max8997_dev', From irq_domain, the sub-block driver
> can get the irq_base and add one of the 'enum max8997_irq' offset when
> registering for interrupt notifications.

There's no GPIOs with interrupt support (even if they're not implemented
yet)?
