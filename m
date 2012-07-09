Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab2GILBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 07:01:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:46983 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab2GILBE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 07:01:04 -0400
Message-ID: <1341831612.3462.29.camel@twins>
Subject: Re: [PATCH v4 3/5] ARM: topology: Update cpu_power according to DT
 information
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux@arm.linux.org.uk, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, yong.zhang0@gmail.com, namhyung@kernel.org,
        jean.pihet@newoldbits.com
Date: Mon, 09 Jul 2012 13:00:12 +0200
In-Reply-To: <CAMQu2gydOEVK_fzmzkdrBwBfOq6eZG=0QfLUfFChWJu9unSn2A@mail.gmail.com>
References: <1341826026-6504-1-git-send-email-vincent.guittot@linaro.org>
	 <1341826026-6504-4-git-send-email-vincent.guittot@linaro.org>
	 <CAMQu2gydOEVK_fzmzkdrBwBfOq6eZG=0QfLUfFChWJu9unSn2A@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 16:25 +0530, Shilimkar, Santosh wrote:
> Having that support would greatly help for the SOC's which have not
> yet
> reached to stage where entire SOC is DT compliant and want to use
> big.LITTLE infrastructure. 

Good incentive to get there though.. :-)
