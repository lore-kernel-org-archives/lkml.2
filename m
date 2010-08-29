Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0H2KK6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 06:10:58 -0400
Received: from 1wt.eu ([62.212.114.60]:42766 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab0H2KK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 06:10:57 -0400
Date: Sun, 29 Aug 2010 12:10:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Miguel Gaio <miguel.gaio@efixo.com>, Juhos Gabor <juhosg@openwrt.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Florian Fainelli <florian@openwrt.org>
Subject: Re: [PATCH] GPIO: add support for NXP 74HC164 GPIO expander
Message-ID: <20100829101034.GB16004@1wt.eu>
References: <461057.78283.qm@web180310.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461057.78283.qm@web180310.mail.gq1.yahoo.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 04:18:51PM -0700, David Brownell wrote:
> 
> --- On Sat, 8/28/10, Florian Fainelli <florian@openwrt.org> wrote:
> 
> > This patch adds support for
> > NXP's 74HC164 GPIO expander.
> 
> The 74164 parts are standard 74xxx series
> discrete logic parts sold by many vendors
> as 8 bit shift registers ... and in many
> logic series (HC, HCT, more).
> 
> At least describe this as generic to all
> those 8-bit shift registers, not just NXP.

Indeed, that was my concern too.

(...)
> p.s. I'd have to pull out my data sheet collection
> to verify, but it might be the 74163 which can
> be used as an 8 bit parallel to serial (input)
>  shift register...

no, it's the 74165. But it would be worth supporting
both !

Willy

