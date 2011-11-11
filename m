Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab1KKI0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 03:26:33 -0500
Received: from mga03.intel.com ([143.182.124.21]:57553 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab1KKI0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 03:26:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,494,1315206000"; 
   d="scan'208";a="35729550"
Date: Fri, 11 Nov 2011 08:37:40 +0000
From: Alan Cox <alan@linux.intel.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH] pch_uart: Fix DMA resource leak issue
Message-ID: <20111111083740.3e02c46a@bob.linux.org.uk>
In-Reply-To: <1320976527-6142-1-git-send-email-tomoya.rohm@gmail.com>
References: <1320976527-6142-1-git-send-email-tomoya.rohm@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> MODIFICATION:
>   Currently, when release DMA channel resource, this driver checks
> dma-flag. However, this specification occurs the above issue.
>   This driver must check whether dma_request_channel is executed or
> not. The values are saved in private data variable "chan_tx/chan_tx".
>   These variables mean if the value is NULL, DMA channel is not
> requested, if not NULL, DMA channel is requested.
> 
> This patch fixes the issue.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>

Acked-by: Alan Cox <alan@linux.intel.com>
