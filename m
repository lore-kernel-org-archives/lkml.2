Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab2GILEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 07:04:32 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:59945 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128Ab2GILEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 07:04:30 -0400
MIME-Version: 1.0
In-Reply-To: <1341831612.3462.29.camel@twins>
References: <1341826026-6504-1-git-send-email-vincent.guittot@linaro.org>
 <1341826026-6504-4-git-send-email-vincent.guittot@linaro.org>
 <CAMQu2gydOEVK_fzmzkdrBwBfOq6eZG=0QfLUfFChWJu9unSn2A@mail.gmail.com> <1341831612.3462.29.camel@twins>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Mon, 9 Jul 2012 16:34:05 +0530
Message-ID: <CAMQu2gzEZgUfCThWHjK-pbd1Ede4n0jeO9YoV=QPWS+n7LPZ9Q@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] ARM: topology: Update cpu_power according to DT information
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux@arm.linux.org.uk, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, yong.zhang0@gmail.com, namhyung@kernel.org,
        jean.pihet@newoldbits.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 4:30 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2012-07-09 at 16:25 +0530, Shilimkar, Santosh wrote:
>> Having that support would greatly help for the SOC's which have not
>> yet
>> reached to stage where entire SOC is DT compliant and want to use
>> big.LITTLE infrastructure.
>
> Good incentive to get there though.. :-)

Sure and I guess thats the thought process from
Vincent too :-)

Regards
Santosh
