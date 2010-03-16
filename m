Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965970Ab0CPCGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 22:06:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51703
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965940Ab0CPCGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 22:06:33 -0400
Date: Mon, 15 Mar 2010 19:06:53 -0700 (PDT)
Message-Id: <20100315.190653.247529535.davem@davemloft.net>
To: keil@b1-systems.de
Cc: torvalds@linux-foundation.org, lars.ellenberg@linbit.com,
       netdev@vger.kernel.org, andreas@eversberg.eu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ISDN: Add PCI ID for HFC-2S/4S Beronet Card PCIe
From: David Miller <davem@davemloft.net>
In-Reply-To: <201003160208.57232.keil@b1-systems.de>
References: <1268668176.12629@pingi>
	<20100315.160133.67908104.davem@davemloft.net>
	<201003160208.57232.keil@b1-systems.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karsten Keil <keil@b1-systems.de>
Date: Tue, 16 Mar 2010 02:08:57 +0100

> Is here some plan to cleanup drivers for -next and remove IDs from pci_ids.h,
> or should it not changed for old  entries ?

Leave things as they are for existing ones.
