Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab1JPBP6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 21:15:58 -0400
Received: from smtp-out.google.com ([74.125.121.67]:57763 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab1JPBP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 21:15:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=Of6GmwU+9u8FTeQLspcgqdhMCzzXNgn3NKWdhV5y2Rb55cR1byTAAlMYdrWtKVk6k
	NTiCh74Eez1aQU2ZKGlIg==
Date: Sat, 15 Oct 2011 18:15:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: James Bottomley <James.Bottomley@hansenpartnership.com>
cc: Andi Kleen <andi@firstfloor.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [patch] parisc, iommu: add missing include for prefetchw()
In-Reply-To: <1318726615.7271.59.camel@dabdike.int.hansenpartnership.com>
Message-ID: <alpine.DEB.2.00.1110151810220.5728@chino.kir.corp.google.com>
References: <20111013233818.GB26654@one.firstfloor.org> <1318631204.3018.101.camel@dabdike.int.hansenpartnership.com> <alpine.DEB.2.00.1110151536310.25063@chino.kir.corp.google.com> <1318722499.7271.54.camel@dabdike.int.hansenpartnership.com>
 <alpine.DEB.2.00.1110151739330.5728@chino.kir.corp.google.com> <1318726615.7271.59.camel@dabdike.int.hansenpartnership.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Oct 2011, James Bottomley wrote:

> > > How did you try to compile this file?
> > > 
> > 
> > make allyesconfig
> > make drivers/parisc/sba_iommu.o
> 
> OK, so just take one of the standard configs ... I don't think anyone's
> tried much randconfig testing over parisc, most of the configuration
> lore is handed down from the mountain on stone tablets.
> 

This isn't randconfig, it's allyesconfig, and this is the only compile 
error that I got while trying to reproduce your percpu.c compile failure.  
Everything else works fine.
