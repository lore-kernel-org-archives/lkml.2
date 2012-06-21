Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760762Ab2FVAMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 20:12:35 -0400
Received: from warthog.procyon.org.uk ([90.155.74.18]:53165 "EHLO
	warthog.procyon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760721Ab2FVAMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 20:12:33 -0400
X-Greylist: delayed 3845 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2012 20:12:29 EDT
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1340306406.1773.59.camel@x61.thuisdomein>
References: <1340306406.1773.59.camel@x61.thuisdomein>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: dhowells@redhat.com, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, Richard Kuo <rkuo@codeaurora.org>,
        linux-hexagon@vger.kernel.org, Jonas Bonn <jonas@southpole.se>,
        linux@openrisc.net, Chris Zankel <chris@zankel.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Remove useless wrappers of asm-generic/cpumask.h
X-Mailer: MH-E 8.3.1; nmh 1.3; GNU Emacs 24.1.50
Date: Fri, 22 Jun 2012 00:06:52 +0100
Message-ID: <32429.1340320012@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle <pebolle@tiscali.nl> wrote:

> frv and xtensa both have a header (in their include/asm directories)
> that are thin wrappers around asm-generic/cpumask.h. These wrappers are
> useless, since that header doesn't exist. They are also unused (all
> files including asm/cpumask.h are x86 specific).
> 
> hexagon and openrisc generate similar headers at build time (using a
> generic-y entry in include/asm/Kbuild). These generated headers are
> useless and unused too.
> 
> Remove these headers and generic-y entries.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: David Howells <dhowells@redhat.com> [FRV]
