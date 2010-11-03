Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab0KCOob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 10:44:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:57746 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab0KCOoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 10:44:30 -0400
Date: Wed, 3 Nov 2010 10:44:29 -0400 (EDT)
From: Jiri Kosina <jkosina@suse.cz>
To: gimli <gimli@dark-green.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Resend  [PATCH 3/4] MacbookAir3,1 and 3,2 hid support
In-Reply-To: <dfe20d79428280b911bd98629a8baac9@mognix.dark-green.com>
Message-ID: <alpine.LNX.2.00.1011031043520.15851@pobox.suse.cz>
References: <66c1cd33ff5b2d908b2b31defb8e0cd1@mognix.dark-green.com> <3e6b335b371a07cd60221a25c5b6b47d@mognix.dark-green.com> <alpine.LNX.2.00.1011030918410.15851@pobox.suse.cz> <7b3b313ce7138c19191295a645dfb38f@mognix.dark-green.com>
 <alpine.LNX.2.00.1011030953540.15851@pobox.suse.cz> <dfe20d79428280b911bd98629a8baac9@mognix.dark-green.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Nov 2010, gimli wrote:

> 
> On Wed, 3 Nov 2010 09:56:21 -0400 (EDT), Jiri Kosina <jkosina@suse.cz>
> wrote:
> > On Wed, 3 Nov 2010, gimli wrote:
> > 
> >> Does this look better ? 
> > 
> > What I would actually prefer would be something like
> > 
> > 
> > 	if ( ... )
> > 		table = macbookair_fn_keys;
> > 	else if ( ... )
> > 		table = powerbook_fn_keys;
> > 	else
> > 		table = apple_fn_keys;
> > 
> > 	apple_find_translation(table, usage->code);
> > 
> >> I also use the USB id's for the if.
> Next try.

I have slightly modified the code to be more like what I proposed above, 
and applied the patch. Thanks a lot,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
