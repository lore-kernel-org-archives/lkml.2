Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab0GNQXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 12:23:36 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:45875 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab0GNQXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 12:23:35 -0400
Date: Wed, 14 Jul 2010 19:12:01 +0300
From: Alexander Shishkin <virtuoso@slind.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kbuild@vger.kernel.org,
        Sebastian =?utf-8?Q?Dalfu=C3=9F?= <sd@sedf.de>,
        Oliver Hartkopp <oliver@hartkopp.net>,
        Michael Guntsche <mike@it-loops.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Michael Tokarev <mjt@tls.msk.ru>,
        Alek Du <alek.du@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Russell King <rmk@arm.linux.org.uk>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] implement size_append in perl
Message-ID: <20100714161201.GD23436@shisha.kicks-ass.net>
References: <1279116063-4499-1-git-send-email-virtuoso@slind.org>
 <4C3DCFB3.1090801@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3DCFB3.1090801@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 07:54:43 -0700, H. Peter Anvin wrote:
> On 07/14/2010 07:01 AM, Alexander Shishkin wrote:
> > +size_append = $(PERL) -e 'print pack("V", (stat "$(lastword $1)")[7])'
> 
> Why the "lastword"?

There's a whitespace right after it due to it being part of the target
spec "$(obj)/piggy.$(suffix_y) FORCE", where "FORCE" is being filtered
out.

Regards,
--
Alex
