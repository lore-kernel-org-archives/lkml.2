Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab1FGRWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 13:22:15 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:56478 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab1FGRWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 13:22:13 -0400
Date: Tue, 7 Jun 2011 11:22:11 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        qi.wang@intel.com, yong.y.wang@intel.com,
        toshiharu-linux@dsn.okisemi.com, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [RESEND]: RE: [PATCH v2 3/3] pch_gpio: support interrupt function
Message-ID: <20110607172211.GF17754@ponder.secretlab.ca>
References: <4DEDBE90.3090305@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEDBE90.3090305@dsn.okisemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 03:00:48PM +0900, Tomoya MORINAGA wrote:
> Hi Grant,
> 
> Let me resend again.
> I haven't received your answer the following my question yet.
> 
> On Friday, May 27, 2011 4:09 PM, Grant Likely wrote:
> > Take a look at the new irq_chip_generic infrastructure.  You don't
> > need to implement a memory mapped irq controller from scratch anymore.
> > Most of the access functions can be taken directly from
> > irq_chip_generic instead.
> 
> Let me clarify your saying.
>   a) We shouldn't use request_irq( ) ?
>   b) Does Your  "irq_chip_generic" mean irq_set_handler_data( ) /
> irq_set_chained_handler( ) ?
>       If yes, Using these functions, I saw IRQ shared other function's
> interrupt becomes invalid.
> 

No, I'm saying that you don't need to implement new irq_chip
operations if you use the new irq_chip_generic implementation.

g.
