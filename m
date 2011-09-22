Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab1IVCoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 22:44:12 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:63411 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1IVCoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 22:44:10 -0400
Date: Wed, 21 Sep 2011 22:44:04 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
In-Reply-To: <20110922114923.86a2325300e87eeaef151b1a@canb.auug.org.au>
Message-ID: <alpine.LFD.2.00.1109212243000.12663@xanadu.home>
References: <20110922114923.86a2325300e87eeaef151b1a@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Sep 2011, Stephen Rothwell wrote:

> Hi Arnd,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-nuc93x/Makefile.boot between commit 86783a0c544d ("ARM:
> 7022/1: allow to detect conflicting zreladdrs") from the arm tree and
> commit 6adc1e7ff19d ("ARM: mach-nuc93x: delete") from the arm-soc tree.
> 
> The latter removes the file that the former updates, so i did that.

That is correct.


Nicolas
