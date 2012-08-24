Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab2HXVqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 17:46:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41636 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab2HXVqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 17:46:45 -0400
Message-ID: <5037F641.3000602@wwwdotorg.org>
Date: Fri, 24 Aug 2012 15:46:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Gyungoh Yoo <jack.yoo@maxim-ic.com>, devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4] mfd: add MAX8907 core driver
References: <1345048126-24054-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1345048126-24054-1-git-send-email-swarren@wwwdotorg.org>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 10:28 AM, Stephen Warren wrote:
> From: Gyungoh Yoo <jack.yoo@maxim-ic.com>
> 
> The MAX8907 is an I2C-based power-management IC containing voltage
> regulators, a reset controller, a real-time clock, and a touch-screen
> controller.

Samuel,

Does this look OK now? (although you're probably traveling to a
conference right now...)
