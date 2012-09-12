Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760442Ab2ILQ3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:29:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34014 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760432Ab2ILQ3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:29:08 -0400
Message-ID: <5050B850.807@wwwdotorg.org>
Date: Wed, 12 Sep 2012 10:29:04 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Gyungoh Yoo <jack.yoo@maxim-ic.com>, devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 REPOST] mfd: add MAX8907 core driver
References: <1346973015-7252-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1346973015-7252-1-git-send-email-swarren@wwwdotorg.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 05:10 PM, Stephen Warren wrote:
> From: Gyungoh Yoo <jack.yoo@maxim-ic.com>
> 
> The MAX8907 is an I2C-based power-management IC containing voltage
> regulators, a reset controller, a real-time clock, and a touch-screen
> controller.

Samuel,

This patch as-is won't compile due to the mfd_add_devices() API change.
Do you want to fix this up when you apply (simply add an extra parameter
"NULL" to the mfd_add_devices() call), or should I send an updated V5
for this?

Thanks.
