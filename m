Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab1JMQRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:17:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab1JMQRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:17:03 -0400
Date: Thu, 13 Oct 2011 18:17:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] parisc: Kconfig: cleanup Kernel page size
 default
In-Reply-To: <1318494916.8345.17.camel@x61.thuisdomein>
Message-ID: <alpine.LNX.2.00.1110131816540.14768@pobox.suse.cz>
References: <1318423872.2336.19.camel@x61.thuisdomein>  <4E96A14C.5050408@suse.cz> <1318494916.8345.17.camel@x61.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, Paul Bolle wrote:

> > > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > > ---
> > > "Kernel page size" still defaults to "4KB", for both 32 and 64 bit
> > > processors, when tested with "make ARCH=parisc menuconfig", which is
> > > good.
> > 
> > I think this paragraph would be nice to have in the changelog.
> 
> Fine with me. Jiri, should I amend my patch and resend?

No need to resend. Thanks,

-- 
Jiri Kosina
SUSE Labs
