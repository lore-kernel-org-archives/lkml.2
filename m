Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab0ENUNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 16:13:43 -0400
Received: from mail.atheros.com ([12.36.123.2]:25028 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab0ENUNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 16:13:42 -0400
Date: Fri, 14 May 2010 13:13:39 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Bruno Randolf <br1@einfach.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
Message-ID: <20100514201339.GB28198@tux>
References: <4BEC7A84.3010503@gmail.com>
 <201005141520.30802.br1@einfach.org>
 <4BECEE3E.6090303@gmail.com>
 <201005141538.43416.br1@einfach.org>
 <4BED6F19.3040608@gmail.com>
 <20100514165325.GA28198@tux>
 <4BED8765.8040307@gmail.com>
 <AANLkTiky103uOz38yZPlLypEQ8DnkdCk1X3zPl9014Yi@mail.gmail.com>
 <67773379-350A-42D4-BEB5-DAC7D8277615@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <67773379-350A-42D4-BEB5-DAC7D8277615@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 12:04:15PM -0700, Justin P. Mattock wrote:
> 
> 
> On May 14, 2010, at 10:29 AM, "Luis R. Rodriguez" <lrodriguez@atheros.com 
>  > wrote:
> 
> > On Fri, May 14, 2010 at 10:24 AM, Justin P. Mattock
> > <justinmattock@gmail.com> wrote:
> >
> >>
> >> here you go:
> >> (I was grabbing the info
> >> after rmmod and modprobe)
> >>
> >> [    7.034242] ATH9K: cachelsz: 256
> >> [   69.175348] ATH9K: cachelsz: 256
> >
> > Close, so I without any patches applied, and by just running  
> > modprobe as below:
> >
> >
> > modprobe ath9k debug=0x00000200
> >
> >               ath_print(common, ATH_DBG_CONFIG, "cachelsz %u  
> > rxbufsize %u\n",
> >                               common->cachelsz, common->rx_bufsize);
> >
> >
> > This is already in the code so just please do this:
> >
> > rmmod ath9k
> > modprobe ath9k debug=0x00000200
> > dmesg | grep cachelsz
> 
> O.k. I did a git reset to the origin
> Then the above, unfortunantly nothing
> Shows up when grepping
> Any CONFIG options I might be missing?

CONFIG_ATH_DEBUG

  Luis
