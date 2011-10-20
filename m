Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab1JTDmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 23:42:21 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:54348 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864Ab1JTDmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 23:42:20 -0400
Message-ID: <4E9F9892.9070007@ti.com>
Date: Thu, 20 Oct 2011 09:12:10 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Shawn Guo <shawn.guo@freescale.com>, patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract regulator_init_data
References: <1318263578-7407-1-git-send-email-rnayak@ti.com> <1318263578-7407-4-git-send-email-rnayak@ti.com> <20111016145536.GA29885@S2100-06.ap.freescale.net> <4E9BAC4D.3010402@ti.com> <20111018115836.GC30703@S2100-06.ap.freescale.net> <20111018160046.GD28501@opensource.wolfsonmicro.com> <20111019053354.GB31162@S2100-06.ap.freescale.net> <20111019144734.GI18713@sirena.org.uk> <20111019150448.GB32007@S2100-06.ap.freescale.net> <20111019151031.GA4275@opensource.wolfsonmicro.com>
In-Reply-To: <20111019151031.GA4275@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 October 2011 08:40 PM, Mark Brown wrote:
> The problem is that the DT is supposed to be separate to the kernel and
> the decisions can depend on what the kernel is currently capable of.
> When the data is embedded in the kernel it's not an issue as the data is
> attached to the rest of the code, when the data becomes detatched from
> the kernel it becomes an issue.

completely agreed.

>
> I don't see any issue with leaving some things out of the DT bindings;
> you were the one raising that as a concern.

The problem is, that there doesn't seem to be a clean way to embed
*board data* into the kernel with DT, if left out of the DT bindings.
There is the auxdata way of still attaching platform_data, but that I
thought was a stopgap for just handling function pointers.
