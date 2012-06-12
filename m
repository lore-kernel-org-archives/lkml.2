Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab2FLPro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:47:44 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:35971 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752463Ab2FLPrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:47:42 -0400
Date: Tue, 12 Jun 2012 08:47:35 -0700
From: Mike Turquette <mturquette@ti.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, mturquette@linaro.org,
        s.hauer@pengutronix.de, sboyd@codeaurora.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, skannan@codeaurora.org,
        shawn.guo@linaro.org
Subject: Re: [PATCH v3 0/4] DT clock bindings
Message-ID: <20120612154735.GB19410@gmail.com>
References: <1339512111-11172-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339512111-11172-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120612-09:41, Rob Herring wrote:
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

Hi Rob,

Just FYI, I was following the first thread but it did not seem to reach
resolution.  Namely Saravana seemed to have some lingering concerns.
But I'm definitely not ignoring this series.  I assume you still want
this to go through me once everyone is on board?

Regards,
Mike
