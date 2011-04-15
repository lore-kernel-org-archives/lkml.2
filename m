Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab1DOOPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:15:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:37240 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485Ab1DOOPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:15:23 -0400
Subject: Re: Regression from 2.6.36
From: Mel Gorman <mgorman@suse.de>
To: azurIt <azurit@pobox.sk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Changli Gao <xiaosuo@gmail.com>,
        Am?rico Wang <xiyou.wangcong@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <20110415152130.AECAA367@pobox.sk>
References: <1302178426.3357.34.camel@edumazet-laptop>
	 <BANLkTikxWy-Pw1PrcAJMHs2R7JKksyQzMQ@mail.gmail.com>
	 <1302190586.3357.45.camel@edumazet-laptop>
	 <20110412154906.70829d60.akpm@linux-foundation.org>
	 <BANLkTincoaxp5Soe6O-eb8LWpgra=k2NsQ@mail.gmail.com>
	 <20110412183132.a854bffc.akpm@linux-foundation.org>
	 <1302662256.2811.27.camel@edumazet-laptop>
	 <20110413141600.28793661.akpm@linux-foundation.org>
	 <20110414102501.GE11871@csn.ul.ie> <20110415115903.315DEAA1@pobox.sk>
	 <20110415104700.GD22688@suse.de>  <20110415125651.68156745@pobox.sk>
	 <1302866247.12428.25.camel@machina.109elm.lan>
	 <20110415133644.12504ADB@pobox.sk>
	 <1302872460.12428.27.camel@machina.109elm.lan>
	 <20110415152130.AECAA367@pobox.sk>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 15 Apr 2011 15:15:20 +0100
Message-ID: <1302876920.12428.36.camel@machina.109elm.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-15 at 15:21 +0200, azurIt wrote:
> So it's really not necessary ? It would be better for us if you can go without it cos it means to run buggy kernel for one more day.
> 

I can live without it.

> Which kernel versions will include this fix ?
> 

As it's a performance fix, I would guess 2.6.39 only. I don't think
-stable pick up performance fixes but I could be wrong.

-- 
Mel Gorman
SUSE Labs

