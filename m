Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab0LHMgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 07:36:53 -0500
Received: from smtpeu1.atmel.com ([195.65.72.27]:57194 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab0LHMgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 07:36:52 -0500
Subject: Re: [PATCH 4/4] avr32: at32ap700x: specify DMA src and dst masters
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1290510371-23077-5-git-send-email-jamie@jamieiles.com>
References: <1290510371-23077-1-git-send-email-jamie@jamieiles.com>
	 <1290510371-23077-5-git-send-email-jamie@jamieiles.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Wed, 08 Dec 2010 13:36:45 +0100
Message-ID: <1291811805.2794.2.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Dec 2010 12:36:46.0709 (UTC) FILETIME=[93CCB250:01CB96D4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 11:06 +0000, Jamie Iles wrote: 
> Now that the dw_dmac DMA driver supports configurable source and
> destination masters we need to specify which ones to use. This was
> previously hardcoded to 0 and 1 respectively in the driver.
> 
> Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

-- 
Hans-Christian Egtvedt

