Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab1JDQPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:15:25 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56718 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab1JDQPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:15:23 -0400
Date: Tue, 4 Oct 2011 10:15:19 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH 1/5 v2] spi-topcliff-pch: add tx-memory clear after
 complete transmitting
Message-ID: <20111004161519.GA10840@ponder.secretlab.ca>
References: <1315296998-7296-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315296998-7296-1-git-send-email-tomoya-linux@dsn.okisemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 05:16:34PM +0900, Tomoya MORINAGA wrote:
> Currently, in case of reading date from SPI flash,
> command is sent twice.
> The cause is that tx-memory clear processing is missing .
> This patch adds the tx-momory clear processing.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
> v2: v1 patch series are included invalid patch file

Merged all 5 patches, thanks.

g.

