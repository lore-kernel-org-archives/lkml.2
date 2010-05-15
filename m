Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab0EOAwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 20:52:08 -0400
Received: from mail.atheros.com ([12.36.123.2]:45168 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671Ab0EOAwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 20:52:03 -0400
Date: Fri, 14 May 2010 17:52:01 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Bruno Randolf <br1@einfach.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Miles Lane <miles.lane@gmail.com>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
Message-ID: <20100515005201.GH28198@tux>
References: <201005141538.43416.br1@einfach.org>
 <4BED6F19.3040608@gmail.com>
 <20100514165325.GA28198@tux>
 <4BED8765.8040307@gmail.com>
 <AANLkTiky103uOz38yZPlLypEQ8DnkdCk1X3zPl9014Yi@mail.gmail.com>
 <67773379-350A-42D4-BEB5-DAC7D8277615@gmail.com>
 <20100514201339.GB28198@tux>
 <4638F7CF-1E00-411F-A086-BA30809E00BD@gmail.com>
 <20100514205253.GC28198@tux>
 <B796B1C7-D7CC-457A-9C86-7C70EA9451CF@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <B796B1C7-D7CC-457A-9C86-7C70EA9451CF@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 03:32:48PM -0700, Justin P. Mattock wrote:
> ATH9K: cachelsz 256 rxbufsize 3904

OK I see nothing odd with these values, and I do not see how
these values can make ath_rxbuf_alloc() barf. I'd like to
reproduce this myself at least once, I left iperf running over
night with no rants from SLAB. I should note this should be
reproducible with RX only if it is ath_rxbuf_alloc() to blame
but without a concrete reproducible instructions it is hard
to guess what to do and if this can only come up during RX.

Can you describe a little more when you have seen this? What
were you doing exactly, for how long? When was the last time
you saw this, what were you doing then?

  Luis
