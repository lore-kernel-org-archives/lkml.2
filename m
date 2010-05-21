Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab0EUNXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 09:23:15 -0400
Received: from n71.bullet.mail.sp1.yahoo.com ([98.136.44.36]:22062 "HELO
	n71.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753874Ab0EUNXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 09:23:13 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 775812.87556.bm@omp119.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=oFS9ShUi8SzPmY1fPbVWzSZD3hoIfUFTVyZryln2tP5MHQ+9b1eGF1Anh+5VWVESrTVJL73vxk4U5COWATc9dEzHfk+22fGEt44e/wTkWE3DF6hnSl2b3NSnbgF2EGMrIPdXwXhew9LaZ+yed+SNbqTo95Yfgm92a4XvZxQHG/s=;
Message-ID: <663067.14695.qm@web180316.mail.gq1.yahoo.com>
X-YMail-OSG: qoSqrZkVM1mCD_FLOmOU8KHG7csY8p2zDP5xoYN4TOJBtHS
 csaXTRE2fWGtkYarvkVf_9qeAI23KDnfuDintYoeTXA3L1IvAUVUITF3Nws1
 K3v9XTgYx6TM7P_KrKz2LPeIZCcY0Y3oCO48_iMXwbWaV2D3CAxhTRyCHbMy
 32kLLBEz.EnIkI_qTz3W2lK5ijWsFdEpNaCeEXBsOyiAIV_jYlQLJosJso_e
 KsHG4Gy3S2tChStG43K54Mlixkk0Wm2OttHMjeiegSYux3_2Pwkn2XMLK4Tw
 tHW6WHdElInPgia3yXw--
X-Mailer: YahooMailClassic/11.0.8 YahooMailWebService/0.8.103.269680
Date: Fri, 21 May 2010 06:23:12 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 1/5] gpiolib: introduce set_debounce method
To: felipe.balbi@nokia.com
Cc: "Balbi Felipe \(Nokia-D/Helsinki\)" <felipe.balbi@nokia.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100521064925.GF925@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Not all GPIOs have hardware debounce though, so
> offering this
> > capability sort of begs the question of where/how to
> provide a software debounce mechanism too...
> 
> how about adding a flag for supported features and if that
> hardware doesn't support we simply return,

Presense of a debounce method would suffice when gpiolib is
in use (vs direct implementation of the API provided by gpiolib).


> or fallback to
> software emulation if chosen by the user. 

ISTR that if you look back to the original discussion about
GPIO debouncing, you will find such a software implementation;
and maybe such an integration ... 


