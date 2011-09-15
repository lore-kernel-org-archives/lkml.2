Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935048Ab1IOV0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 17:26:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934922Ab1IOV0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 17:26:04 -0400
Date: Thu, 15 Sep 2011 17:25:58 -0400 (EDT)
Message-Id: <20110915.172558.450897137285997811.davem@redhat.com>
To: toshiharu-linux@dsn.okisemi.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        tomoya-linux@dsn.okisemi.com
Subject: Re: [PATCH 1/3] pch_gbe: fixed the issue which receives an
 unnecessary packet.
From: David Miller <davem@redhat.com>
In-Reply-To: <1314922809-4041-1-git-send-email-toshiharu-linux@dsn.okisemi.com>
References: <1314922809-4041-1-git-send-email-toshiharu-linux@dsn.okisemi.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Date: Fri,  2 Sep 2011 09:20:07 +0900

> This patch fixed the issue which receives an unnecessary packet before link
> 
> When using PHY of GMII, an unnecessary packet is received,
> And it becomes impossible to receive a packet after link up.
> 
> Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>

Applied.
