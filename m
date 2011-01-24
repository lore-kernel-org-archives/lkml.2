Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab1AXOzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 09:55:18 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:41596 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1AXOzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 09:55:14 -0500
Subject: Re: [PATCH repost 2/4] dmaengine/dw_dmac: allow src/dst masters to
 be configured at runtime
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Jamie Iles <jamie.iles@picochip.com>
In-Reply-To: <1295619115-18420-3-git-send-email-jamie@jamieiles.com>
References: <1295619115-18420-1-git-send-email-jamie@jamieiles.com>
	 <1295619115-18420-3-git-send-email-jamie@jamieiles.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Mon, 24 Jan 2011 15:54:57 +0100
Message-ID: <1295880898.2903.2.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jan 2011 14:54:59.0138 (UTC) FILETIME=[ABE33220:01CBBBD6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 14:11 +0000, Jamie Iles wrote: 
> Some platforms have flexible mastering capabilities and this needs
> to be selected at runtime. If the platform has specified private
> data in the form of the dw_dma_slave then fetch the source and
> destination masters from here. If this isn't present, default to
> the previous of 0 and 1.
> 
> v2: cleanup whitespace
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> Signed-off-by: Jamie Iles <jamie.iles@picochip.com>

Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

<snipp>

-- 
Hans-Christian Egtvedt

