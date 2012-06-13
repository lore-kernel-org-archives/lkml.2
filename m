Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab2FMP17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:27:59 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17430 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430Ab2FMP14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:27:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 13 Jun 2012 08:27:34 -0700
Date: Wed, 13 Jun 2012 18:26:58 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Rob Herring <robherring2@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v3 0/4] DT clock bindings
Message-ID: <20120613152658.GE32111@tbergstrom-lnx.Nvidia.com>
References: <1339512111-11172-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1339512111-11172-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 04:41:47PM +0200, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> This series defines clock bindings for Device-Tree and adds kernel
> support using the common clock infrastructure. The last patch enables
> DT clock support for the Calxeda Highbank platform.
> 
> I'm posting this again to solicit further review. There has been some
> discussion[1], but no definite path forward. This series is not changed
> from the last post other than rebasing to v3.5-rc2.
> 
> Rob
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2012-May/100932.html
> 

How would this binding work for clocks which can take a spinlock pointer as a
init parameter (eg. clk-gate).

Cheers,

Peter.
