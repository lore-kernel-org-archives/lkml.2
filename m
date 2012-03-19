Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304Ab2CSWrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:47:23 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11717 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab2CSWrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:47:21 -0400
Date: Mon, 19 Mar 2012 23:46:33 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Joe Perches <joe@perches.com>
cc: linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Ed Okerson <eokerson@quicknet.net>,
        Greg Herlein <gherlein@quicknet.net>,
        "David W. Erhart" <derhart@quicknet.net>,
        John Sellers <jsellers@quicknet.net>,
        Mike Preston <mpreston@quicknet.net>,
        David Huggins-Daines <dhd@cepstral.com>,
        Fabio Ferrari <fabio.ferrari@digitro.com.br>,
        Artis Kugevics <artis@mt.lv>, Daniele Bellucci <bellucda@tiscali.it>
Subject: Re: [PATCH 1/2] drivers/telephony/ixj.c::add_caps(): don't rely on
 undefined behaviour
In-Reply-To: <1332197078.7847.1.camel@joe2Laptop>
Message-ID: <alpine.LNX.2.00.1203192345020.9012@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1203192332420.9012@swampdragon.chaosbits.net> <1332197078.7847.1.camel@joe2Laptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012, Joe Perches wrote:

> On Mon, 2012-03-19 at 23:37 +0100, Jesper Juhl wrote:
> > In drivers/telephony/ixj.c::add_caps() we have several statements like this:
> > 
> >   	j->caplist[j->caps].handle = j->caps++;
> > 
> > That's undefined behaviour right there.
> 
> telephony has been moved to staging.

Since when? Where?

In my up-to-date Linus tree with HEAD at 
c16fa4f2ad19908a47c63d8fa436a1178438c7e7, that file is is still in 
drivers/telephony/, not in staging/...

/confused

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

