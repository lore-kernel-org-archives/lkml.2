Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab1B1Piu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:38:50 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:53684 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab1B1Pit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:38:49 -0500
Date: Mon, 28 Feb 2011 16:29:44 +0100
From: Harald Welte <HaraldWelte@viatech.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 3/3] mfd: vx855: add MODULE_DEVICE_TABLE
Message-ID: <20110228152944.GL27912@prithivi.gnumonks.org>
References: <1298874735.5562.3.camel@mola>
 <1298874867.5562.7.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298874867.5562.7.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Mon, Feb 28, 2011 at 02:34:27PM +0800, Axel Lin wrote:
> The device table is required to load modules based on modaliases.
> After adding the MODULE_DEVICE_TABLE, below entries will be added to
> modules.pcimap:
> vx855                0x00001106 0x00008409 0xffffffff 0xffffffff 0x00000000 0x00000000 0x0
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Harald Welte <laforge@gnumonks.org>

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
