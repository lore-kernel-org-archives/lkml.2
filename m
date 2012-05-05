Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab2EEVYO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 17:24:14 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:40499 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751152Ab2EEVYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 17:24:13 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1+bMmZL1rSbgoKLAEXW3JfKsSrLPm+OZk/4lJDlUP
	/g+9YGT/KK9hhl
Message-ID: <4FA59A75.8080402@gmx.de>
Date: Sat, 05 May 2012 23:24:05 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: John David Anglin <dave.anglin@bell.net>
CC: Mikulas Patocka <mpatocka@redhat.com>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix compile failure on PA-RISC
References: <Pine.LNX.4.64.1205042250130.18896@file.rdu.redhat.com> <1798237.g4OIBKAx4s@donald.sf-tec.de> <Pine.LNX.4.64.1205051445360.2623@file.rdu.redhat.com> <BLU0-SMTP81AFFA5151451BADCB23B3972D0@phx.gbl>
In-Reply-To: <BLU0-SMTP81AFFA5151451BADCB23B3972D0@phx.gbl>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2012 10:09 PM, John David Anglin wrote:
> On 5-May-12, at 2:55 PM, Mikulas Patocka wrote:
> 
>> I acknowledge that your patches work. So send them directly to Linus. I
>> think there is not much maintenance being done on PA-RISC.
> 
> James wrote back in March "I haven't yet actually tried git head on parisc
> (and I won't be able to until I actually get my machines back [currently being
> shipped across the atlantic]) but if there's a problem it will show up quickly:
> parisc actually uses cpu hotplug to boot its secondary cpus."

> Helge resigned due to lack of time.

I'm still alive and was still reading the mailing list.
And I'm planning to test some newer kernels very soon again :-)
So, many thanks from my side to everyone who sent patches in the past
(incl. Mikulas, Rolf and others).

Helge
