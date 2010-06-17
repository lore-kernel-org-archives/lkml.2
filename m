Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab0FQTSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 15:18:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:37148 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933154Ab0FQTSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 15:18:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,433,1272870000"; 
   d="scan'208";a="290131561"
Date: Thu, 17 Jun 2010 21:18:21 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
       Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH] MFD: AB8500 mask off irrelevant bits from the SPI
 message
Message-ID: <20100617191820.GA17699@sortiz.org>
References: <1275008384-17285-1-git-send-email-linus.walleij@stericsson.com>
 <AANLkTim_j9atBiKb5L536l33UDE_nYVgIbu4gaJcUMu3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim_j9atBiKb5L536l33UDE_nYVgIbu4gaJcUMu3@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, Jun 17, 2010 at 06:46:42PM +0200, Linus Walleij wrote:
> 2010/5/28 Linus Walleij <linus.walleij@stericsson.com>:
> 
> > The registers on the AB8500 are only 8 bits wide, so the content
> > of the remaining bits is undefined. Let's mask off the undefined
> > stuff when returning a register in an SPI read.
> 
> Are you picking this one up Samuel?
Yes, sorry for the delay, I've been quite busy with other projects but will go
through my MFD backlog in a day or 2.

Cheers,
Samuel.


> Yours,
> Linus Walleij

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
