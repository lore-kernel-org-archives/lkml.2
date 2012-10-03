Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab2JCABy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 20:01:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932747Ab2JCABw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 20:01:52 -0400
Date: Wed, 3 Oct 2012 02:01:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use
 request_firmware_nowait()
In-Reply-To: <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1210030159440.31999@twin.jikos.cz>
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com> <4FE37194.30407@redhat.com> <4FE8B8BC.3020702@iki.fi> <4FE8C4C4.1050901@redhat.com> <4FE8CED5.104@redhat.com> <20120625223306.GA2764@kroah.com> <4FE9169D.5020300@redhat.com>
 <20121002100319.59146693@redhat.com> <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com> <20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com> <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2012, Linus Torvalds wrote:

> And see this email from Kay Sievers that shows that it was all known
> about and intentional in the udev camp:
> 
>   http://www.spinics.net/lists/netdev/msg185742.html

This seems confusing indeed.

That e-mail referenced above is talking about loading firmware at ifup 
time. While that might work for network device drivers (I am not sure even 
about that), what are the udev maintainers advice for other drivers, where 
there is no analogy to ifup?

-- 
Jiri Kosina
SUSE Labs

