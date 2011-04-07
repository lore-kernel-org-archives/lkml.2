Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab1DGWcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:32:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51830
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755867Ab1DGWcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:32:23 -0400
Date: Thu, 07 Apr 2011 15:31:46 -0700 (PDT)
Message-Id: <20110407.153146.48488128.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, bheglaas@google.com, monstr@monstr.eu,
        tglx@linuxtronix.de, bigeasy@linuxtronix.de
Subject: Re: [PATCHES] Generalize PCI <-> OF node matching
From: David Miller <davem@davemloft.net>
In-Reply-To: <1302215455.2458.46.camel@pasglop>
References: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
	<20110407.151636.183068185.davem@davemloft.net>
	<1302215455.2458.46.camel@pasglop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Fri, 08 Apr 2011 08:30:55 +1000

> I'm surprised it would have changed that significantly since then but
> I'll check & fixup, I can send a new one later today. I'll make sure to
> specify the "anchor" commit next time.

It's the spelling fixes bomb that went into Linus's tree eariler
today.
