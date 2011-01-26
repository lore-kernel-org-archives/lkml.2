Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab1AZTlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:41:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45132 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab1AZTle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:41:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Qkma9YzH1VIyXeSEooTXuHE8ezTgzDZh9ZG6vLMZ00VswSJApDXl+C9u5oyFGNjLaw
         cpggj5kHlv798CwraPmInaE4EEt0ev8aU5q06DnQ1Hf0pctHv1NMhwqA8qinx7iR/opr
         agUENHtEVuTnlk+mxPsVqMXxgC7hx5/XpKCUw=
Date: Wed, 26 Jan 2011 11:41:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110126194127.GE29268@core.coreip.homeip.net>
References: <20110125164803.GA19701@core.coreip.homeip.net>
 <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com>
 <20110125205453.GA19896@core.coreip.homeip.net>
 <4D3F4804.6070508@redhat.com>
 <4D3F4D11.9040302@teksavvy.com>
 <20110125232914.GA20130@core.coreip.homeip.net>
 <20110126020003.GA23085@core.coreip.homeip.net>
 <4D403855.4050706@teksavvy.com>
 <4D405A9D.4070607@redhat.com>
 <4D4076FD.6070207@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4076FD.6070207@teksavvy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 02:33:17PM -0500, Mark Lord wrote:
> On 11-01-26 12:32 PM, Mauro Carvalho Chehab wrote:
> > Em 26-01-2011 13:05, Mark Lord escreveu:
> ..
> >> Nope. Does not work here:
> >>
> >> $ lsinput
> >> protocol version mismatch (expected 65536, got 65537)
> > 
> > You need to relax the version test at the tree. As I said before, this is
> > a development tool from the early RC days, bound to work with one specific
> > version of the API, and programmed by purpose to fail if there would by any
> > updates at the Input layer.
> ..
> 
> As I said before, I personally have done that on my copy here.
> But that's not what this thread is about.
> 
> This thread is about broken userspace courtesy of these changes.
> So I am testing with the original userspace binary here,
> and it still fails.  And will continue to fail until that regression is fixed.

I do not consider lsinput refusing to work a regression. The tool
claims to work with particular protocol version and it is tool's choice.

Shall I write a utility that checks kernel version and only works with
2.6.37 and yell when we release 2.6.38?

-- 
Dmitry
