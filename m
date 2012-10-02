Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab2JBWMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:12:43 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45826 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475Ab2JBWMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:12:41 -0400
X-Sasl-enc: CvPfpcx9ADo7fhm2nLrwFwNlTFyzIihdneoWLPHY0hx/ 1349215960
Date: Tue, 2 Oct 2012 15:12:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, Kay Sievers <kay@vrfy.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use
 request_firmware_nowait()
Message-ID: <20121002221239.GA30990@kroah.com>
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com>
 <4FE37194.30407@redhat.com>
 <4FE8B8BC.3020702@iki.fi>
 <4FE8C4C4.1050901@redhat.com>
 <4FE8CED5.104@redhat.com>
 <20120625223306.GA2764@kroah.com>
 <4FE9169D.5020300@redhat.com>
 <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 09:33:03AM -0700, Linus Torvalds wrote:
> I don't know where the problem started in udev, but the report I saw
> was that udev175 was fine, and udev182 was broken, and would deadlock
> if module_init() did a request_firmware(). That kind of nested
> behavior is absolutely *required* to work, in order to not cause
> idiotic problems for the kernel for no good reason.
> 
> What kind of insane udev maintainership do we have? And can we fix it?
> 
> Greg, I think you need to step up here too. You were the one who let
> udev go. If the new maintainers are causing problems, they need to be
> fixed some way.

I've talked about this with Kay in the past (Plumbers conference I
think) and I thought he said it was all fixed in the latest version of
udev so there shouldn't be any problems anymore with this.

Mauro, what version of udev are you using that is still showing this
issue?

Kay, didn't you resolve this already?  If not, what was the reason why?

thanks,

greg k-h
