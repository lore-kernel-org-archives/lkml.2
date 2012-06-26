Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab2FZSyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 14:54:33 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:42744 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755324Ab2FZSy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 14:54:29 -0400
Date: Tue, 26 Jun 2012 20:54:28 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Justin Wheeler <jwheeler@datademons.com>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Giel van Schijndel <me@mortis.eu>
Subject: Re: Patch for f71808e_wdt.c.
Message-ID: <20120626185428.GF735@spo001.leaseweb.com>
References: <alpine.DEB.2.00.1206110101290.1027@newbox.vps>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1206110101290.1027@newbox.vps>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Justin,

> I have a Jetway JNF99 motherboard, featuring the F71869 SuperIO chip, but 
> its
> watchdog chipset ID appears to be 1007 (as opposed to 0814).  Some testing
> confirmed it behaves the exact same as 0814.  The short attached patch adds
> that chipset ID to the module's ID list so that the Fintek watchdog driver 
> can
> correctly identify and access it.

Added to linux-watchdog-next.

Kind regards,
Wim.

