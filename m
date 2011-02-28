Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab1B1I5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 03:57:14 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:48881 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab1B1I5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 03:57:13 -0500
Date: Mon, 28 Feb 2011 09:45:07 +0100
From: Harald Welte <laforge@gnumonks.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/3] mfd: pcf50633-core: add MODULE_DEVICE_TABLE
Message-ID: <20110228084507.GH27912@prithivi.gnumonks.org>
References: <1298874735.5562.3.camel@mola>
 <1298874792.5562.4.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298874792.5562.4.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 02:33:12PM +0800, Axel Lin wrote:
> The device table is required to load modules based on modaliases.
> After adding the MODULE_DEVICE_TABLE, below entries will be added to
> modules.alias:
> alias i2c:pcf50633 pcf50633
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Harald Welte <laforge@gnumonks.org>

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
