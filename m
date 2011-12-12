Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab1LLXpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:45:04 -0500
Received: from d1.icnet.pl ([212.160.220.21]:37275 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab1LLXo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:44:59 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 01/10] GPIO: gpio-generic: Move initialization up to postcore
Date: Tue, 13 Dec 2011 00:44:01 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-serial@vger.kernel.org
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl> <201112130005.35386.jkrzyszt@tis.icnet.pl> <20111212231519.GK32251@atomide.com>
In-Reply-To: <20111212231519.GK32251@atomide.com>
MIME-Version: 1.0
Message-Id: <201112130044.02007.jkrzyszt@tis.icnet.pl>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 of December 2011 at 00:15:20, Tony Lindgren wrote:
> 
> Might be worth checking if some board specific __initcall helps here
> too?

If I only knew how I could insert a board specific __initcall between 
two points from where the generic-gpio first, then the 8250 driver, are 
called.

Any hints?

Thanks,
Janusz
