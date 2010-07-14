Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab0GNPXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 11:23:42 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:42209 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab0GNPXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 11:23:41 -0400
Date: Wed, 14 Jul 2010 17:23:37 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: linux-kbuild@vger.kernel.org, Sebastian Dalfu? <sd@sedf.de>,
        Oliver Hartkopp <oliver@hartkopp.net>,
        Michael Guntsche <mike@it-loops.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Michael Tokarev <mjt@tls.msk.ru>,
        Alek Du <alek.du@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Russell King <rmk@arm.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] implement size_append in perl
Message-ID: <20100714152337.GA13125@merkur.ravnborg.org>
References: <1279116063-4499-1-git-send-email-virtuoso@slind.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279116063-4499-1-git-send-email-virtuoso@slind.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 05:01:03PM +0300, Alexander Shishkin wrote:
> The current implementation has been several times fixed to work around
> different shells and build environments and it remains a somewhat tricky
> shell script. This patch replaces all the dependencies by a single line
> of perl. Build dependency on perl is not new, so that shouldn't be a
> problem.
> 
> The new implementation does exactly what it's supposed to: it outputs
> a little-endian 32-bit unsigned integer of a file's length.
> 
> This might simplify matters with different build environments and
> different shells and is also considerably shorter and hopefully more
> readable.

Reminds me that I had a patch that moved this to mkpiggy.c.
Goggle gave this hit:

    http://lists.openwall.net/linux-kernel/2009/12/20/92

I will try to update this to cover arm also and check
if other archs needs this.

In other word - move thes size stuff to mkpiggy so we
skip this extra step.

	Sam
