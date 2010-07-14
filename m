Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab0GNUuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:50:22 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:34017 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468Ab0GNUuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:50:18 -0400
Date: Wed, 14 Jul 2010 23:48:22 +0300
From: Alexander Shishkin <virtuoso@slind.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
        Sebastian Dalfu? <sd@sedf.de>, Oliver Hartkopp <oliver@hartkopp.net>,
        Michael Guntsche <mike@it-loops.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Michael Tokarev <mjt@tls.msk.ru>,
        Alek Du <alek.du@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Russell King <rmk@arm.linux.org.uk>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] implement size_append in perl
Message-ID: <20100714204822.GF23436@shisha.kicks-ass.net>
References: <1279116063-4499-1-git-send-email-virtuoso@slind.org>
 <20100714152337.GA13125@merkur.ravnborg.org>
 <20100714161704.GE23436@shisha.kicks-ass.net>
 <4C3DEC90.8060603@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3DEC90.8060603@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 09:57:52 -0700, H. Peter Anvin wrote:
> On 07/14/2010 09:17 AM, Alexander Shishkin wrote:
> > 
> > Hm, maybe this mkpiggy can be made arch-independent and moved to scripts/
> > as well?
> > 
> 
> It depends on which architectures want this wrapping format.

Yes, well, when it's more than one, it already kind of makes sense.

Regards,
--
Alex
