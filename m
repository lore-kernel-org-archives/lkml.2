Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab0I0Gof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 02:44:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42816
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752614Ab0I0Goe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 02:44:34 -0400
Date: Sun, 26 Sep 2010 23:44:54 -0700 (PDT)
Message-Id: <20100926.234454.241435433.davem@davemloft.net>
To: masa-korg@dsn.okisemi.com
Cc: randy.dunlap@oracle.com, john.linn@xilinx.com, ralf@linux-mips.org,
        kristoffer@gaisler.com, mbizon@freebox.fr, gregory.v.rose@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        okada533@dsn.okisemi.com, shimizu394@dsn.okisemi.com,
        morinaga526@dsn.okisemi.com, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        margie.foster@intel.com, meego-dev@meego.com
Subject: Re: [PATCH v6] Gigabit Ethernet driver of Topcliff PCH
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CA03198.8080802@dsn.okisemi.com>
References: <4CA03198.8080802@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Date: Mon, 27 Sep 2010 14:54:32 +0900

> Gigabit Ethernet driver of Topcliff PCH
> 
> Topcliff PCH is the platform controller hub that is going to be used in
> Intel's upcoming general embedded platform. All IO peripherals in
> Topcliff PCH are actually devices sitting on AMBA bus. 
> Topcliff PCH has Gigabit Ethernet I/F. Using this I/F, it is able to 
> access system devices connected to Gigabit Ethernet.
> 
> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>

I already added your driver to my net-next-2.6 tree, why are
you sending this again? :-(
