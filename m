Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab0FDLwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 07:52:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47542 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753915Ab0FDLwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 07:52:40 -0400
Date: Fri, 4 Jun 2010 13:00:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew <andrew.chih.howe.khor@intel.com>,
       Intel OTC <joel.clark@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Message-ID: <20100604130050.2b555944@lxorguk.ukuu.org.uk>
In-Reply-To: <4C08D268.6000404@dsn.okisemi.com>
References: <4C08D268.6000404@dsn.okisemi.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*!
> + * @ingroup	PHUB_PCILayerAPI
> + * @fn		static void __exit pch_phub_pci_exit(void)
> + * @brief	Provides the functionality of exiting the module
> + * */

Can we please do something about all this stuff first so the code is
easier to review by those not familiar with the kernel format.

I sent a bit of code out last time that did most of the work

Alan
