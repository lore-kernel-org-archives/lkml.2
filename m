Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab0FHHzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 03:55:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39181 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751227Ab0FHHzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 03:55:37 -0400
Date: Tue, 8 Jun 2010 09:04:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
       "Andrew" <andrew.chih.howe.khor@intel.com>,
       "Intel OTC" <joel.clark@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Message-ID: <20100608090409.6fe6e410@lxorguk.ukuu.org.uk>
In-Reply-To: <4C0DCE87.1090802@dsn.okisemi.com>
References: <4C0DCE87.1090802@dsn.okisemi.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This makes it hard to build one kernel for everything
> We couldn't understand your intention.
> Does the above mean we must not use "#ifdef PCH_CAN_PCLK_50MHZ"	in source code ?

The problem for people building kernels is this

- They want to have a single kernel for all the boxes of a single
  architecture
- They cannot do this if there are compile time settings that only work
  on some boards


Ideally this should be done automatically. If not then can it be a module
parameter instead ?

Alan
