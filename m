Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab2FNVlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 17:41:25 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:41562 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab2FNVlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 17:41:24 -0400
Date: Thu, 14 Jun 2012 23:41:43 +0200
From: Borislav Petkov <bp@amd64.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jim Cromie <jim.cromie@gmail.com>, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, pawel.moll@arm.com, jbaron@redhat.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] init: add comments to keep initcall-names in sync with
 initcall levels
Message-ID: <20120614214143.GD32312@aftab.osrc.amd.com>
References: <20120612105913.GA8404@aftab.osrc.amd.com>
 <1339699862-3731-1-git-send-email-jim.cromie@gmail.com>
 <1339701783.5981.5.camel@x61.thuisdomein>
 <CAJfuBxxBD5eiMMTW5+q6LEpv+WLcbcsxxY6eEjbaTVCFqBeKmA@mail.gmail.com>
 <1339708913.5981.16.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339708913.5981.16.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 11:21:53PM +0200, Paul Bolle wrote:
> > > What problem does this solve?
> > 
> > kernel/params.c  and other builtins are also modules - at least wrt
> > how theyre reported by dynamic_debug:
> > 
> > kernel/params.c:121 [params]parse_one =_ "Unknown argument `%s'\012"
> > kernel/params.c:117 [params]parse_one =_ "Unknown argument: calling %p\012"
> > kernel/params.c:108 [params]parse_one =_ "They are equal!  Calling %p\012"
> > kernel/params.c:188 [params]parse_args =_ "Parsing ARGS: %s\012"
> > 
> > The advice to avoid those macros does not apply to builtin "modules"
> 
> I don't think I use dynamic_debug, but still, a pair of square brackets
> doesn't make that some part of the kernel is considered to be a module,
> does it? And more importantly, even if there's a difference between
> "module" and "loadable module", which I rather doubt, aren't the people
> who are expected to read this comment also expected to understand the
> relevance of the preceding 
>     #else /* MODULE */
> 
> line?

I don't understand one thing: what's wrong with adding another word to
the comment so that it explicitly states what "modules" this comment is
referring to?

Can you give me at least one technical reason against the comment being
as precise as possible, even to the point of tautology. So what if it
says "loadable modules"? I don't see anything wrong with that.

So please, let's drop the bikeshedding and get on with our lives :-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
