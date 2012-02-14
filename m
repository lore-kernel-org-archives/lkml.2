Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860Ab2BNJNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 04:13:40 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:59002 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab2BNJNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 04:13:37 -0500
Date: Tue, 14 Feb 2012 08:52:25 +0100
From: Harald Welte <laforge@gnumonks.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: Make pcf50633_write_block() return 0 on success
Message-ID: <20120214075225.GA3954@prithivi.gnumonks.org>
References: <1329190231.4285.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329190231.4285.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, Feb 14, 2012 at 11:30:31AM +0800, Axel Lin wrote:
> The callers of pcf50633_write_block assume pcf50633_write_block return 0 on
> success, thus make it return 0 instead of the number of registers written on
> success.

This change seems to make a lot of sense, thanks for spotting it.

Acked-by: Harald Welte <laforge@gnumonks.org>

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
