Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab2GWPPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:15:08 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44926 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab2GWPPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:15:07 -0400
Date: Mon, 23 Jul 2012 16:14:56 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: wei_wang@realsil.com.cn
Cc: gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers/misc: Add realtek card reader core driver
Message-ID: <20120723151456.GA24745@srcf.ucam.org>
References: <1343036558-8189-1-git-send-email-wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343036558-8189-1-git-send-email-wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 05:42:38PM +0800, wei_wang@realsil.com.cn wrote:
> +SUBSYSTEM=="rtsx_cr", ENV{RTSX_CARD_TYPE}=="SD", RUN+="/sbin/modprobe -bv rtsx_sdmmc"

Ugh. Expose a modalias instead? I know tifm does it like this, but 
that's probably also an argument for fixing tifm.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
