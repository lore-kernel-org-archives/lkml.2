Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab1CNUCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:02:11 -0400
Received: from kroah.org ([198.145.64.141]:43408 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab1CNUCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:02:08 -0400
Date: Mon, 14 Mar 2011 12:59:37 -0700
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Subject: Re: [PATCH v2 10/12] Introduce CONFIG_GOOGLE_FIRMWARE
Message-ID: <20110314195937.GA594@kroah.com>
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
 <20110312014347.6133.4388.stgit@mike.mtv.corp.google.com>
 <20110314154510.GE31340@kroah.com>
 <AANLkTimz7P9D6HKe1JN2ihg4TVsaDJ3y255CP3b0FJsT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimz7P9D6HKe1JN2ihg4TVsaDJ3y255CP3b0FJsT@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 12:49:17PM -0700, Mike Waychison wrote:
> On Mon, Mar 14, 2011 at 8:45 AM, Greg KH <greg@kroah.com> wrote:
> > On Fri, Mar 11, 2011 at 05:43:47PM -0800, Mike Waychison wrote:
> >> In order to keep Google's firmware drivers organized amongst themselves,
> >> create a new directory for them to live in.  As well, all Google
> >> firmware drivers are gated on CONFIG_GOOGLE_FIRMWARE=y, which defaults
> >> to 'n' in the kernel build.
> >
> > Everything defaults to 'n' in the kernel build system, so this really
> > isn't a big deal :)
> 
> Well, I was hoping that we could have options gating on
> CONFIG_GOOGLE_FIRMWARE, but default to 'y'.  This makes our lives a
> bit easier as it means we have a single switch we need to enable on
> our side and all the options we care about (presumably all
> google-specific drivers) get enabled.
> 
> If you have strong objections to this, I can flip the default values
> of the specific config options to 'n' as well though...

As decreed by Linus and others, all new config options should default to
'n', unless your box is going to blow up into tiny pieces if you don't
select it.

thanks,

greg k-h
