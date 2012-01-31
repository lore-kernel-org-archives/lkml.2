Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2AaBTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:19:36 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:44184 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2AaBTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:19:35 -0500
Date: Mon, 30 Jan 2012 20:19:29 -0500 (EST)
Message-Id: <20120130.201929.1758603770664566022.davem@davemloft.net>
To: tomoya.rohm@gmail.com
Cc: jeffrey.t.kirsher@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH 1/3] ethernet/pch_gbe: Change company name OKI
 SEMICONDUCTOR to LAPIS Semiconductor
From: David Miller <davem@davemloft.net>
In-Reply-To: <CANKRQniQs95kUhyDeP2V7cyOFE1gyi-ihZufmNoi_SGSXm3MGQ@mail.gmail.com>
References: <1327643159-1302-1-git-send-email-tomoya.rohm@gmail.com>
	<20120130.125219.2077768183344205118.davem@davemloft.net>
	<CANKRQniQs95kUhyDeP2V7cyOFE1gyi-ihZufmNoi_SGSXm3MGQ@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 30 Jan 2012 17:19:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Date: Tue, 31 Jan 2012 09:35:26 +0900

> I can understand your saying.
> 
> If I post like below, is this patch acceptable for you ?
> +       tristate "OKI/LAPIS SEMICONDUCTOR IOH(ML7223/ML7831) GbE"
> 
> BTW, I think need consistency for "Change company/product name" as a
> whole of linux.
> Because other patches for the same series "change company name" I
> posted have already accepted.
> e.g.(GPIO, USB device, DMA, UART, I2C)

I mainly object to moving the driver around, and failing to retain
the old name especially in user visible contexts such as Kconfig
variables, help text, and module parameters.
