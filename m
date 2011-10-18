Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab1JRGwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:52:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1268 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab1JRGwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:52:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=rsmpkIrUibI2TwabYbygN/Zh09pGhRPL8J60lPIMq87QT5qc17ORQiffAE1Rp8/mB
	WUuSWF5k9+yZYRhnsTgrQ==
Date: Mon, 17 Oct 2011 23:52:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: gpio-ml-ioh: Support interrupt function
In-Reply-To: <4E9D1ED8.3070106@dsn.lapis-semi.com>
Message-ID: <alpine.DEB.2.00.1110172350500.8959@chino.kir.corp.google.com>
References: <20111017201058.GA13916@elgon.mountain> <4E9CC93B.4000800@dsn.lapis-semi.com> <alpine.DEB.2.00.1110172251590.4880@chino.kir.corp.google.com> <4E9D1ED8.3070106@dsn.lapis-semi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Tomoya MORINAGA wrote:

> Hi, David
> Thank you for your information.
> I will try to test with '-1'.
> 
> After testing with '-1',
> I will post the patch for this.
> 

Please try with NUMA_NO_NODE, that's what the slab allocators use and will 
be the ones consuming this.  It's available in include/linux/numa.h.
