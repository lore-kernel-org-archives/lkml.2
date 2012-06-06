Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2FFFIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 01:08:52 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:36511 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750994Ab2FFFIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 01:08:50 -0400
Message-ID: <4FCEE5DA.7090403@ti.com>
Date: Wed, 06 Jun 2012 10:38:42 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: David Collins <collinsd@codeaurora.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: Supporting non-device tree consumers with device tree regulator
 drivers
References: <4FCE30D6.7060102@codeaurora.org>
In-Reply-To: <4FCE30D6.7060102@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 June 2012 09:46 PM, David Collins wrote:
> In the long term, this problem should go away of its own accord.  However,
> in the short term, many systems are converting over to using device tree.
>   Therefore, we are left with a situation currently where some regulator
> consumer drivers are being probed via device tree and some are being
> probed via board file devices within a single platform.

Is this a situation you are facing in your mainline kernel or internal
trees? What you explain would need you to work with hybrid board files
with some devices created through device tree and some others statically
from the board file in the kernel, and that approach was already shot
down as unacceptable.
