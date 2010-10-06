Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715Ab0JFIY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 04:24:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57089 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758636Ab0JFIYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 04:24:25 -0400
Date: Wed, 6 Oct 2010 10:24:22 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/4] dmaengine: Add Freescale i.MX1/21/27 DMA driver
Message-ID: <20101006082422.GT28242@pengutronix.de>
References: <1285854995-6569-1-git-send-email-s.hauer@pengutronix.de> <1285854995-6569-5-git-send-email-s.hauer@pengutronix.de> <4CABB1B9.4080002@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CABB1B9.4080002@intel.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:23:20 up 94 days, 23:34, 13 users,  load average: 0.39, 0.31,
	0.32
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 04:16:09PM -0700, Dan Williams wrote:
>> +       unsigned int                    channel;
>> +       unsigned int                    imxdma_channel;
>> +
>> +       enum dma_data_direction         direction;
>
> Why does the channel have a direction isn't that a function of the  
> transaction?  It's also unused.
>
>> +       enum dma_slave_buswidth         word_size;
>> +       dma_addr_t                      bd_phys;
>
> unused?
>
>> +       unsigned long                   flags;
>
> unused?

Sorry, it seems I was a bit too fast posting it. I'll send an updated
version.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
