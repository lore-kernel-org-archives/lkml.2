Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935064Ab1IOV0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 17:26:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934922Ab1IOV0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 17:26:11 -0400
Date: Thu, 15 Sep 2011 17:26:06 -0400 (EDT)
Message-Id: <20110915.172606.1299101209691432178.davem@redhat.com>
To: toshiharu-linux@dsn.okisemi.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        tomoya-linux@dsn.okisemi.com
Subject: Re: [PATCH 2/3] pch_gbe: added the process of FIFO over run error
From: David Miller <davem@redhat.com>
In-Reply-To: <1314922809-4041-2-git-send-email-toshiharu-linux@dsn.okisemi.com>
References: <1314922809-4041-1-git-send-email-toshiharu-linux@dsn.okisemi.com>
	<1314922809-4041-2-git-send-email-toshiharu-linux@dsn.okisemi.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Date: Fri,  2 Sep 2011 09:20:08 +0900

> This patch added the processing which should be done to hardware,
> when a FIFO over run error occurred.
> 
> Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>

Applied.
