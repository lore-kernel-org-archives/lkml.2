Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0HIFe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 01:34:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41688
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751775Ab0HIFeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 01:34:25 -0400
Date: Sun, 08 Aug 2010 22:34:44 -0700 (PDT)
Message-Id: <20100808.223444.62324566.davem@davemloft.net>
To: dilinger@queued.net
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] sparc: make driver/of/pdt no longer sparc-specific
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100809013245.1cefb9bf@dev.queued.net>
References: <20100808231116.21c7d6f3@dev.queued.net>
	<AANLkTimG7u5eXWSn5VznKfuFcFD+evTzo1_QpAFmCdpL@mail.gmail.com>
	<20100809013245.1cefb9bf@dev.queued.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andres Salomon <dilinger@queued.net>
Date: Mon, 9 Aug 2010 01:32:45 -0400

> On Sun, 8 Aug 2010 23:12:21 -0600
> Grant Likely <grant.likely@secretlab.ca> wrote:
> 
>> If you have to explicitly cast these function pointers, then you're
>> doing it wrong.  :-)  Listen to and fix the compiler complaint here.
>> 
> 
> Hm, can you please expand on that?  The reason it's necessary to cast is
> because sparc's prom_* functions are using ints instead of phandles.  I
> don't understand why casting is the wrong thing here.
> 
> I could write some 1-line wrapper functions that simply call prom_*
> rather than casting, I suppose.

There's no reason the Sparc interfaces can't take phandles since they
are just ints, and that would make the call signatures of these
functions compatible with the types used by the other architectures.
