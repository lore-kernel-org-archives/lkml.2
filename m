Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab1CNPuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:50:01 -0400
Received: from kroah.org ([198.145.64.141]:50423 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755736Ab1CNPt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:49:59 -0400
Date: Mon, 14 Mar 2011 08:47:56 -0700
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tim Hockin <thockin@google.com>, "H. Peter Anvin" <hpa@kernel.org>,
        Mike Waychison <mikew@google.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        San Mehat <san@google.com>
Subject: Re: [PATCH v2 12/12] driver: Google Memory Console
Message-ID: <20110314154756.GG31340@kroah.com>
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
 <20110312014358.6133.34911.stgit@mike.mtv.corp.google.com>
 <4D7D9F92.5010604@kernel.org>
 <AANLkTik5iAPou_bPa4xk6iR27sOk2yrexaaTUe-g=VEe@mail.gmail.com>
 <4D7DA16F.5010601@kernel.org>
 <20110314092220.GA18058@elte.hu>
 <AANLkTikXE+rMj1GHqZq6YpZOj1_PQJ-K4t8WeVKgsG_B@mail.gmail.com>
 <20110314142315.GA1638@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314142315.GA1638@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 03:23:15PM +0100, Ingo Molnar wrote:
> 
> * Tim Hockin <thockin@google.com> wrote:
> 
> > This same BIOS logic is used across a number of Platforms.  We could
> > use something like the vendor strings to trigger this code off, [...]
> 
> Correct.
> 
> > [...] I suppose, but ick.  It's already in a google/ subdir and wrapped with 
> > CONFIG_GOOGLE_MEMCONSOLE.
> 
> That's not the point though - in this day and age we simply do not add non-generic 
> hacks like that - we've come a long way since the ISA days. The point is to make it 
> safe enough to limit its effects not just to CONFIG_GOOGLE_MEMCONSOLE but also to 
> affected hardware only.

I strongly agree, we can't take this as-is without this type of code
added to the driver, sorry.

Thanks,

greg k-h
