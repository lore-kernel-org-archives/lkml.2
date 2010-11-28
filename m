Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab0K1Bkk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 20:40:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35374
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830Ab0K1Bki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 20:40:38 -0500
Date: Sat, 27 Nov 2010 17:41:03 -0800 (PST)
Message-Id: <20101127.174103.104047424.davem@davemloft.net>
To: toshiharu-linux@dsn.okisemi.com
Cc: linux@treblig.org, randy.dunlap@oracle.com, john.linn@xilinx.com,
        ralf@linux-mips.org, kristoffer@gaisler.com, mbizon@freebox.fr,
        gregory.v.rose@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, masa-korg@dsn.okisemi.com,
        qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        margie.foster@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH 2/2] pch_gbe driver: The wrong of initializer entry
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CEA069D.20009@dsn.okisemi.com>
References: <4CEA069D.20009@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Date: Mon, 22 Nov 2010 14:58:53 +0900

> The wrong of initializer entry was modified.
> 
> Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>

How about you give some credit to David Alan Gilbert who made
you aware of this issue?
