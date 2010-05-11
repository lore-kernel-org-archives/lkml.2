Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102Ab0EKXkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 19:40:32 -0400
Received: from kroah.org ([198.145.64.141]:55029 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab0EKXka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 19:40:30 -0400
Date: Tue, 11 May 2010 16:32:21 -0700
From: Greg KH <greg@kroah.com>
To: Dinh Nguyen <Dinh.Nguyen@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-usb@vger.kernel.org, s.hauer@pengutronix.de,
       valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
       bryan.wu@canonical.com, amit.kucheria@canonical.com,
       Jun.Li@freescale.com, xiao-lizhang@freescale.com
Subject: Re: [PATCHv2 2.6.34-rc7 2/3] mx5: change usb clock source from
 pll3 to pll2
Message-ID: <20100511233221.GA31311@kroah.com>
References: <1273508519-23033-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1273508519-23033-2-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273508519-23033-2-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 11:21:58AM -0500, Dinh Nguyen wrote:
> For power management reasons, pll2 should be used to source the USBOH3
> clock for mx51. PLL3 can be completely gated off when USB is not used.
> 
> This patch applies to 2.6.34-rc7.

Hm, no, it seems to conflict and does not apply :(

I've taken the first one, shouldn't the two others go through some arm
tree?


thanks,

greg k-h
