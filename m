Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab1AXUO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 15:14:57 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34221 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab1AXUOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 15:14:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bFcVq0BkDwW+FhfSRFB+f86K5ME+WDdrimgWXIKaNoqLqSg3ynsPD6Qb4CAceqD0za
         3z/vPoY+aHGofl7lV6fkPWZTKwkIrWGDHi+RUlDLxo6Z6FGWLDHefdmXMeEArwPCSjUL
         /GmFYoDks8+hliaR9N7M5acVDWTtUZ28az9D8=
Date: Mon, 24 Jan 2011 23:14:48 +0300
From: Vasiliy Kulikov <segooon@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: Ryan Mallon <ryan@bluewatersys.com>, Russell King <linux@arm.linux.org.uk>,
        kernel-janitors@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] arch/arm/mach-at91/clock.c: Add missing IS_ERR test
Message-ID: <20110124201447.GA31162@albatros>
References: <1295898922-18822-1-git-send-email-julia@diku.dk>
 <1295898922-18822-3-git-send-email-julia@diku.dk>
 <4D3DD964.9020107@bluewatersys.com>
 <Pine.LNX.4.64.1101242058430.3167@ask.diku.dk>
 <20110124200515.GA30963@albatros>
 <Pine.LNX.4.64.1101242108180.3167@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1101242108180.3167@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 21:09 +0100, Julia Lawall wrote:
> On Mon, 24 Jan 2011, Vasiliy Kulikov wrote:
> > clk_get() is defined per-architecture, sometimes it is NULL only.
> 
> In this case there is a definition in the same file, so it doesn't seem 
> necessary to worry about possible other ones.  Unless there is some goal 
> in the future to remove the local one?

My oppinion is that even such architecture dependent code written in
architecure indepenent way is highly desirable.  Besides more clean code
it is probably review by smaller group of people, so it is potentially
more buggy.


Thanks,

-- 
Vasiliy
