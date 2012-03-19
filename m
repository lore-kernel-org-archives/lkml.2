Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673Ab2CSXK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 19:10:59 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47684 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754059Ab2CSXK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 19:10:58 -0400
Message-ID: <1332198657.7847.7.camel@joe2Laptop>
Subject: Re: [PATCH 1/2] drivers/telephony/ixj.c::add_caps(): don't rely on
 undefined behaviour
From: Joe Perches <joe@perches.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Ed Okerson <eokerson@quicknet.net>,
        Greg Herlein <gherlein@quicknet.net>,
        "David W. Erhart" <derhart@quicknet.net>,
        John Sellers <jsellers@quicknet.net>,
        Mike Preston <mpreston@quicknet.net>,
        David Huggins-Daines <dhd@cepstral.com>,
        Fabio Ferrari <fabio.ferrari@digitro.com.br>,
        Artis Kugevics <artis@mt.lv>, Daniele Bellucci <bellucda@tiscali.it>
Date: Mon, 19 Mar 2012 16:10:57 -0700
In-Reply-To: <alpine.LNX.2.00.1203192345020.9012@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1203192332420.9012@swampdragon.chaosbits.net>
	 <1332197078.7847.1.camel@joe2Laptop>
	 <alpine.LNX.2.00.1203192345020.9012@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 23:46 +0100, Jesper Juhl wrote:
> On Mon, 19 Mar 2012, Joe Perches wrote:
> > On Mon, 2012-03-19 at 23:37 +0100, Jesper Juhl wrote:
> > > In drivers/telephony/ixj.c::add_caps() we have several statements like this:
> > > 
> > >   	j->caplist[j->caps].handle = j->caps++;
> > > 
> > > That's undefined behaviour right there.
> > telephony has been moved to staging.
> Since when? Where?
> In my up-to-date Linus tree with HEAD at 
> c16fa4f2ad19908a47c63d8fa436a1178438c7e7, that file is is still in 
> drivers/telephony/, not in staging/...
> /confused

In the -next tree.

Yes, it's a bug fix, but drivers/telephony is pretty dead.

