Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab1AXO7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 09:59:23 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:18242 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab1AXO7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 09:59:22 -0500
Subject: Re: [PATCH repost 4/4] avr32: at32ap700x: specify DMA src and dst
 masters
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <1295619115-18420-5-git-send-email-jamie@jamieiles.com>
References: <1295619115-18420-1-git-send-email-jamie@jamieiles.com>
	 <1295619115-18420-5-git-send-email-jamie@jamieiles.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Mon, 24 Jan 2011 15:59:14 +0100
Message-ID: <1295881154.2903.7.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jan 2011 14:59:15.0826 (UTC) FILETIME=[44E2AD20:01CBBBD7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 14:11 +0000, Jamie Iles wrote: 
> Now that the dw_dmac DMA driver supports configurable source and
> destination masters we need to specify which ones to use. This was
> previously hardcoded to 0 and 1 respectively in the driver.
> 
> Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

<snipp>

-- 
Hans-Christian Egtvedt

