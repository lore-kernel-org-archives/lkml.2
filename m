Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab0LVVeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 16:34:06 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:40009 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab0LVVeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 16:34:05 -0500
Date: Wed, 22 Dec 2010 14:34:03 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Frank Rowand <frank.rowand@am.sony.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Prevent users from disabling tickless
Message-ID: <20101222213403.GP1263@parisc-linux.org>
References: <20101221233942.GL1263@parisc-linux.org> <4D1266F5.8040702@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D1266F5.8040702@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 01:00:37PM -0800, Frank Rowand wrote:
> Why remove the ability to make the configuration choice?  Why not
> just add the info about performance impact to the help text and
> let me shoot myself in the foot (that is the unix way (tm)) if
> I desire to?

$ wc -l .config
2601 .config

It's too hard to get every single config option right ... unless it's a
works / doesn't work choice, having a "make my performance suck" config
option is a bad idea.  I didn't even know I had this config option
set the wrong way until I ran powertop on my desktop, implemented its
recommendations for things I'd screwed up in my .config, then reran the
tests I was doing.

Someone with a big server might not run powertop, so wouldn't be
told they'd got it run.  Sure, we could write a special tool to
check peoples config options to see if they've got some common
config options set wrongly ... but I'm rather reminded of Brazil.
http://farm1.static.flickr.com/50/109556460_5362c5f2b5_o.jpg

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
