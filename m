Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762084Ab2COTEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:04:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53126 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759503Ab2COTEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:04:47 -0400
X-Sasl-enc: NvSDI3GsDFA6x96hHyibarTwoSB+mc68LnxOo+5Q6Oj6 1331838285
Date: Thu, 15 Mar 2012 12:04:44 -0700
From: Greg KH <greg@kroah.com>
To: Aneesh V <aneesh@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 0/7] Add TI EMIF SDRAM controller driver
Message-ID: <20120315190444.GE11142@kroah.com>
References: <1331835457-5390-1-git-send-email-aneesh@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331835457-5390-1-git-send-email-aneesh@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 11:47:30PM +0530, Aneesh V wrote:
> Add a driver for the EMIF SDRAM controller used in TI SoCs
> 
> EMIF is an SDRAM controller that supports, based on its revision,
> one or more of LPDDR2/DDR2/DDR3 protocols.This driver adds support
> for LPDDR2.
> 
> The driver supports the following features:
> - Calculates the DDR AC timing parameters to be set in EMIF
>   registers using data from the device data-sheets and based
>   on the DDR frequency. If data from data-sheets is not available
>   default timing values from the JEDEC spec are used. These
>   will be safe, but not necessarily optimal
> - API for changing timings during DVFS or at boot-up

Is this a kernel/user API, or just an in-kernel API?

thanks,

greg k-h
