Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab0HaIUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 04:20:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53126 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab0HaIUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 04:20:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=ZbkxVLJLAJincqOn2LvOgwD6P2nxRlXxsfxjgHe2rqVCVlr/Yo+3XLo7bXiqEctVUK
         jLxUmwjkYcswBM1JYbU2n3Pnj4kY+oEZFvdHnlVgtMVQlz2CDdNVOptKVWEZb5OWCqck
         KWsyWv2NbmCBjERy2FPHygS/DE3W7zHj/BF84=
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
To: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v2] GPIO: add support for 74HC164 serial-in/parallel-out 8-bit shift register
Date: Tue, 31 Aug 2010 10:17:30 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-server; KDE/4.4.2; x86_64; ; )
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Samuel Ortiz <sameo@linux.intel.com>,
        Miguel Gaio <miguel.gaio@efixo.com>, Juhos Gabor <juhosg@openwrt.org>,
        dbrownell@users.sourceforge.net
References: <887649.75421.qm@web180316.mail.gq1.yahoo.com>
In-Reply-To: <887649.75421.qm@web180316.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008311017.30445.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tuesday 31 August 2010 01:43:04 David Brownell wrote:
> generic to all
> 
> > 74HC164 chips
> 
> Not just HC-series logic, also HCT, AC, etc (as
> I noted previously).
> 
> I'm glad you took NXP (one of the N vendors)
> out of the name, but I think you should also
>  take the logic series out; "74x164 might be sufficiently generic.

Allright, I will respin with those changes. Note that I chose to prefix the 
data structures with gen_ (for obvious C language reasons), I hope this is 
fine.

>            
> 
> > pdata->gpio_pin_clk, err);
> 
> I'm a bit puzzled why you don't just hook the
> chip up using standard SPI signals... ISTR they
> matched up directly to what the chip needs, so
> no GPIOs were needed for interface glue.

The board this driver is being used on had no SPI signals left I think, so it 
was hooked up on separate GPIO lines (which cannot be muxed to the GPIO pad).
--
Florian

