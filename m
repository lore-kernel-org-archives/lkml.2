Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab1HSA7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 20:59:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52997 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab1HSA7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 20:59:04 -0400
Date: Fri, 19 Aug 2011 01:59:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Subject: Re: [PATCH v2 2/2] MFD: MAX8997: Support Wake-up from Suspend
Message-ID: <20110819005900.GA32368@sirena.org.uk>
References: <1313653056-27263-1-git-send-email-myungjoo.ham@samsung.com>
 <1313653056-27263-3-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313653056-27263-3-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Edited for television.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 04:37:36PM +0900, MyungJoo Ham wrote:

> +	if (max8997->wakeup && max8997->irq)
> +		irq_set_irq_wake(max8997->irq, 1);

There's supposed to be userspace control of this stuff (see
device_may_wake_up() and friends) though that can always be added in a
second pass).
