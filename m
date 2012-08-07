Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab2HGLV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:21:26 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:45003 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753651Ab2HGLVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:21:25 -0400
Message-ID: <5020FA2C.2020707@ti.com>
Date: Tue, 07 Aug 2012 16:51:16 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: spi-devel-general@lists.sourceforge.net, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: omap2-mcspi: In case of dma errors fall back to
 pio
References: <1343197229-15188-1-git-send-email-shubhrajyoti@ti.com> <20120807074740.GR11011@atomide.com>
In-Reply-To: <20120807074740.GR11011@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 August 2012 01:17 PM, Tony Lindgren wrote:
>>  };
> Don't you need to check separately for rx and tx dma? There's a slight
> chance that you get a channel for one but not for the other..
In that case I treat it as non usable and fall back to pio.

Are you suggesting that let one channel be dma and only the failed one pio?
