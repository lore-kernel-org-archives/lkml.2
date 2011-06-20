Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab1FTKOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:14:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:21901 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955Ab1FTKOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:14:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,392,1304319600"; 
   d="scan'208";a="18337150"
Date: Mon, 20 Jun 2011 12:14:45 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonicro.com
Subject: Re: [PATCH] mfd: Support multiple active WM831x AUXADC conversions
Message-ID: <20110620101445.GB22420@sortiz-mobl>
References: <1307443648-14193-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307443648-14193-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Jun 07, 2011 at 11:47:28AM +0100, Mark Brown wrote:
> The WM831x AUXADC hardware can schedule multiple conversions at once,
> allowing higher performance when more than one source is in use as we
> can have the hardware start new conversions without having to wait for
> a register write.
> 
> Take advantage of this in the interrupt driven case, maintaining a list of
> callers that are waiting for AUXADC conversions and completing them all
> simultaneously. The external interface of the AUXADC is not changed so
> there will be limited use of the feature immediately.
Patch applied, many thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
