Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab2BCL3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 06:29:49 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:60889 "HELO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753325Ab2BCL3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 06:29:47 -0500
Message-ID: <4F2BC528.6030708@ti.com>
Date: Fri, 03 Feb 2012 13:29:44 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20120106 Thunderbird/9.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Balaji T K <balajitk@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: twl-core: Don't specify regulator consumers by struct
 device
References: <1328267137-4816-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1328267137-4816-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 01:05 PM, Mark Brown wrote:
> This has been deprecated for considerable time now and support has been
> removed from the regulator API. dev_name should be used instead.

Tested-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
