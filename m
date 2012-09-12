Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab2ILGKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:10:32 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:50076 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029Ab2ILGKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:10:30 -0400
Message-ID: <5050273E.3080407@ti.com>
Date: Wed, 12 Sep 2012 11:40:06 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: spi-devel-general@lists.sourceforge.net, grant.likely@secretlab.ca,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: omap2-mcspi: Cleanup the omap2_mcspi_txrx_dma function
References: <1347345800-4116-1-git-send-email-shubhrajyoti@ti.com> <20120912032135.GJ9162@opensource.wolfsonmicro.com>
In-Reply-To: <20120912032135.GJ9162@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2012 08:51 AM, Mark Brown wrote:
> On Tue, Sep 11, 2012 at 12:13:20PM +0530, Shubhrajyoti D wrote:
>> > Currently in omap2_mcspi_txrx_dma the tx and the rx support is
>> > interleaved. Make the rx related code in omap2_mcspi_rx_dma
>> > and the tx related code omap2_mcspi_tx_dma and call the functions.
> I'd ideally like some testing from the OMAP side before applying this -
> is there someone who can give a Tested-by?
I have tested this patch with nfs boot with ethernet being on spi on
omap4sdp and spidev.
On omap3 sdp tested the touchscreen.

However can wait for some tested-bys :-)
