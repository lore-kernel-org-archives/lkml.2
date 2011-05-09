Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab1EIS4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 14:56:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43307
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751933Ab1EIS4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 14:56:01 -0400
Date: Mon, 09 May 2011 11:55:29 -0700 (PDT)
Message-Id: <20110509.115529.59687897.davem@davemloft.net>
To: toshiharu-linux@dsn.okisemi.com
Cc: netdev@vger.kernel.org, tomoya-linux@dsn.okisemi.com,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 1/2] PCH_GbE : Fixed the issue of collision detection
From: David Miller <davem@davemloft.net>
In-Reply-To: <4DC3EF5F.1030306@dsn.okisemi.com>
References: <4DC3EF5F.1030306@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Date: Fri, 06 May 2011 21:53:51 +0900

> The collision detection setting was invalid.
> When collision occurred, because data was not resenr, 
> there was an issue to which a transmitting throughput falls.
> 
> This patch enables the collision detection.
> 
> Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>

Applied.
