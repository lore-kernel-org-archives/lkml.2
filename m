Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab1JQPw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:52:56 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37442 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab1JQPwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:52:54 -0400
MIME-Version: 1.0
In-Reply-To: <1318700142.23438.45.camel@vkoul-udesk3>
References: <1317418715-9666-1-git-send-email-alexandre.bounine@idt.com>
	<1317492077.1573.1839.camel@vkoul-udesk3>
	<0CE8B6BE3C4AD74AB97D9D29BD24E55202291E40@CORPEXCH1.na.ads.idt.com>
	<1317965252.1573.2238.camel@vkoul-udesk3>
	<0CE8B6BE3C4AD74AB97D9D29BD24E552022D6C9A@CORPEXCH1.na.ads.idt.com>
	<1318700142.23438.45.camel@vkoul-udesk3>
Date: Mon, 17 Oct 2011 21:22:53 +0530
Message-ID: <CAJe_ZhdjMTsqSTDwV_zaAQKmCbjOtRVc951wxqKScaCR-DBG9Q@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] RapidIO: Add DMA Engine support for RIO data transfers
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>,
        Dan <dan.j.williams@intel.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 October 2011 23:05, Vinod Koul <vinod.koul@intel.com> wrote:

> Another alternate approach could be to add one more argument to
> prep_slave_sg API which allows us to pass additional runtime specific
> parameters. This can be NULL and unused for existing drivers and used in
> RIO and any future subsystems which want to use dmaengine.
> Thoughts...?
>
That doesn't sound much different than passing the data via
dma_chan.private during prep_slave_sg. Only now we add to
the number of arguments.
And then either this argument would be RapidIO specific (unfair
to other users) or generic. In latter case what would it look like ?
