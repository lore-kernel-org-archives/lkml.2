Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab2HXIvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 04:51:37 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:54213 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932203Ab2HXIvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 04:51:31 -0400
Date: Fri, 24 Aug 2012 10:51:26 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: Build regressions/improvements in v3.6-rc3
Message-ID: <20120824085126.GL27604@spo001.leaseweb.com>
References: <1345754768-4634-1-git-send-email-geert@linux-m68k.org> <5036AC23.8020309@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5036AC23.8020309@xenotime.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randi,

> > *** WARNINGS ***
> > 
> > 6202 regressions:
> >   + Documentation/watchdog/src/watchdog-test.c: warning: no previous prototype for 'term' [-Wmissing-prototypes]:  => 34:6
> 
> 
> patch posted by me... not merged anywhere AFAIK.

is in linux-watchdog-next. Will go to Linus this weekend.

Kind regards,
Wim.

