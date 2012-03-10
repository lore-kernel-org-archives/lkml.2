Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab2CJD4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 22:56:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41570 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab2CJD4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 22:56:23 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/4] spi-topcliff-pch: Fix issue for transmitting over 4KByte
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Wolfram Sang <w.sang@pengutronix.de>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
In-Reply-To: <1323404009-3476-1-git-send-email-tomoya.rohm@gmail.com>
References: <1323404009-3476-1-git-send-email-tomoya.rohm@gmail.com>
Date: Fri, 09 Mar 2012 20:56:20 -0700
Message-Id: <20120310035620.8A8DC3E06B6@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Dec 2011 13:13:27 +0900, Tomoya MORINAGA <tomoya.rohm@gmail.com> wrote:
> Currently, when spi-topcliff-pch receives transmit request over 4KByte,
> this driver can't process correctly. This driver needs to divide the data
> into 4Kbyte unit.
> This patch fixes the issue.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>

Applied, thanks.

g.

