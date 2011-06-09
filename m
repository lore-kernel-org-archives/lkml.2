Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab1FIWo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 18:44:26 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:34154 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756889Ab1FIWoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 18:44:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=u39j/kWdDhdWwnpyyhIzcncuxYjCezXTCXoA8kM7KnOT8+UIE0/YRUwuIBNESNk+UWqKaMM87yb2Oyk8+pDXmEqNs9u8LxnjOwqrBbrOzqaTpQHaJAWvSJ5pqutEOYJy;
Date: Thu, 9 Jun 2011 15:37:42 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Joe Perches <joe@perches.com>
Cc: Andrew Murray <amurray@mpcdata.com>, w.sang@pengutronix.de,
        geert@linux-m68k.org, linux-embedded@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org, udknight@gmail.com,
        namhyung@gmail.com, Andrew Murray <amurray@mpc-data.co.uk>
Subject: Re: [PATCH] printk-formats.txt documentation update
Message-Id: <20110609153742.2ad54aaa.rdunlap@xenotime.net>
In-Reply-To: <1307656829.13329.53.camel@Joe-Laptop>
References: <20110609124549.48117a75.rdunlap@xenotime.net>
	<1307654688-28015-1-git-send-email-amurray@mpcdata.com>
	<20110609145130.7fda9bd1.rdunlap@xenotime.net>
	<1307656829.13329.53.camel@Joe-Laptop>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Jun 2011 15:00:29 -0700 Joe Perches wrote:

> On Thu, 2011-06-09 at 14:51 -0700, Randy Dunlap wrote:
> > On Thu,  9 Jun 2011 22:24:48 +0100 Andrew Murray wrote:
> > > +	For printing-16 byte UUID/GUIDs addresses. The additional 'l', 'L',
> > 	For printing 16-byte
> > You want to resend or shall I just fix it?
> 
> Hey Randy.
> 
> I find your seeming insistence on using a dash
> between the numeric count and the word byte to
> be a bit odd.
> 
> Stylistically, why do you want it there?

Mostly to make it clear.  It's too easy to be ambiguous.


> cheers, Joe

Without hyphen:

	For printing 16 byte UUID/GUIDs addresses.

Those adjectives are confusing.  I don't know what that phrase means.
It could easily mean 16 UUID/GUIDs, but it's ambiguous.

But

	For printing 16-byte UUID/GUIDs addresses.

That means (clearly to me) that UUID/GUIDs are 16-byte entities.

Or see www.incredibleenglish.com/pdf/Hyphens.pdf, section 1,
"Hyphenate unit modifiers."

Or see http://www.ehow.com/how_4473498_use-hyphen-sentence.html, section 1,
"Link compound modifiers with hyphens."

Or see http://www.getitwriteonline.com/archive/040201HyphAdj.htm


HTH.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
