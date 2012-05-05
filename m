Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab2EEUKN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 16:10:13 -0400
Received: from blu0-omc3-s5.blu0.hotmail.com ([65.55.116.80]:10610 "EHLO
	blu0-omc3-s5.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106Ab2EEUKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 16:10:10 -0400
X-Originating-IP: [64.229.84.125]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU0-SMTP81AFFA5151451BADCB23B3972D0@phx.gbl>
From: John David Anglin <dave.anglin@bell.net>
To: Mikulas Patocka <mpatocka@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1205051445360.2623@file.rdu.redhat.com>
Subject: Re: [PATCH] Fix compile failure on PA-RISC
References: <Pine.LNX.4.64.1205042250130.18896@file.rdu.redhat.com> <1798237.g4OIBKAx4s@donald.sf-tec.de> <Pine.LNX.4.64.1205051445360.2623@file.rdu.redhat.com>
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (Apple Message framework v936)
Date: Sat, 5 May 2012 16:09:52 -0400
CC: Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.936)
X-OriginalArrivalTime: 05 May 2012 20:10:09.0133 (UTC) FILETIME=[1208B1D0:01CD2AFB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5-May-12, at 2:55 PM, Mikulas Patocka wrote:

> I acknowledge that your patches work. So send them directly to  
> Linus. I
> think there is not much maintenance being done on PA-RISC.

James wrote back in March "I haven't yet actually tried git head on  
parisc
(and I won't be able to until I actually get my machines back  
[currently being
shipped across the atlantic]) but if there's a problem it will show up  
quickly:
parisc actually uses cpu hotplug to boot its secondary cpus."

Helge resigned due to lack of time.

This is my understanding as to why there is a maintenance gap.

For what I have been doing, I only use stable kernels.  I'm currently
running 3.3.4.

Dave
--
John David Anglin	dave.anglin@bell.net



