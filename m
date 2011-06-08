Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab1FHO5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 10:57:22 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56218 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab1FHO5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 10:57:19 -0400
Date: Wed, 8 Jun 2011 08:57:16 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        qi.wang@intel.com, yong.y.wang@intel.com,
        toshiharu-linux@dsn.okisemi.com, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [RESEND]: RE: [PATCH v2 3/3] pch_gpio: support interrupt function
Message-ID: <20110608145716.GC8499@ponder.secretlab.ca>
References: <4DEDBE90.3090305@dsn.okisemi.com>
 <20110607172211.GF17754@ponder.secretlab.ca>
 <4DEEDEA1.6070200@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEEDEA1.6070200@dsn.okisemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 11:29:53AM +0900, Tomoya MORINAGA wrote:
> (2011/06/08 2:22), Grant Likely wrote:
> >No, I'm saying that you don't need to implement new irq_chip
> >operations if you use the new irq_chip_generic implementation.
> 
> I understand your saying. It seems "new irq_chip_generic" was
> implemented in linux-3.0.
> However "irq_chip_generic" is not implemented in stable kernel
> version. Right ?
> So, first of all, could you accept this patch ?
> After the kernel version becomes stable, I will resubmit a patch for
> "new irq_chip_generic".

Ah, I understand what you're asking.

Sorry, but I cannot pickup this patch for the stable series.  It is a
new feature, not a bug fix.  Only bug fixes should be going into the
stable kernel series.

g.

