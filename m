Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab0HZRgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:36:41 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:33499 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab0HZRgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 13:36:40 -0400
Subject: Re: [RFC] Docbook: allow warning on unused documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100826101130.61f60090.rdunlap@xenotime.net>
References: <1282136967.13315.1.camel@jlt3.sipsolutions.net>
	 <20100826093710.111b103e.rdunlap@xenotime.net>
	 <1282841476.3812.69.camel@jlt3.sipsolutions.net>
	 <20100826101130.61f60090.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Aug 2010 19:36:39 +0200
Message-ID: <1282844199.3812.70.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 10:11 -0700, Randy Dunlap wrote:

> > > How do I test this?  Do I need to add !A to some source file?
> > 
> > Yeah, like to Documentation/DocBook/mac80211.tmpl you could add
> > !Ainclude/net/mac80211.h
> 
> Yes, I see.  That output looks useful.
> 
> How about using !C (for "check") instead of !A ?

Sure, I can't say I care much, had "all" in mind when I came up with !A.

I fixed up the command, and can change that and resend.

johannes

