Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab0KSOi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 09:38:29 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45361 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab0KSOi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 09:38:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VeyfOOWx8cTymPGIbh3534/oPEfgif22S+HfhsitNddeoIU7cfkN4hJOy6P6eZrMn+
         Tmrcofh0T+eA8JOgvrqyy5UOsYyMdiHEcDmPf5Kj5KwR2W8YJl1R+nbbJxAm9n7ort6F
         12pSAOgWMPU9ub09OI37v09ZKjpq+d2VW8TrE=
MIME-Version: 1.0
In-Reply-To: <1290119265.26343.814.camel@calx>
References: <1290049259-20108-1-git-send-email-b32542@freescale.com>
	<1290114908.26343.721.camel@calx>
	<alpine.DEB.2.00.1011181333160.26680@chino.kir.corp.google.com>
	<1290119265.26343.814.camel@calx>
Date: Fri, 19 Nov 2010 22:38:27 +0800
Message-ID: <AANLkTikSw2X-n7mC0+Mxosn8w-AAuROkSV7V9G+8ZAVS@mail.gmail.com>
Subject: Re: [PATCH] slub: operate cache name memory same to slab and slob
From: Zeng Zhaoming <zengzm.kernel@gmail.com>
To: Matt Mackall <mpm@selenic.com>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        cl@linux-foundation.org, penberg@cs.helsinki.fi, tytso@mit.edu,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - eliminate dynamically-allocated names (mostly useless when we start
> merging slabs!)

not permit dynamically allocated name. I think this one is better, but
as a rule, describe in header is not enough.
It is helpful to print out some warning when someone break the rule.

> kmem_cache_name() is also a highly suspect function in a
> post-merged-slabs kernel. As ext4 is the only user in the kernel, and it
> got it wrong, perhaps it's time to rip it out.

agree, kmem_cache_name() is ugly.

---
Best Regards
    Zeng Zhaoming
