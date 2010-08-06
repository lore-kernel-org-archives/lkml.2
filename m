Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935781Ab0HFTRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:17:16 -0400
Received: from acsinet14.oracle.com ([141.146.126.236]:32843 "EHLO
	acsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935054Ab0HFTRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:17:10 -0400
X-Greylist: delayed 1055 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Aug 2010 15:17:09 EDT
Date: Fri, 6 Aug 2010 09:29:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Howells <dhowells@redhat.com>
Cc: smfrench@gmail.com, jlayton@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] DNS: Fixes for the DNS query module
Message-Id: <20100806092902.6555a644.randy.dunlap@oracle.com>
In-Reply-To: <20100806021352.29873.16452.stgit@warthog.procyon.org.uk>
References: <20100806021347.29873.87087.stgit@warthog.procyon.org.uk>
	<20100806021352.29873.16452.stgit@warthog.procyon.org.uk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Aug 2010 03:13:52 +0100 David Howells wrote:

> Fixes for the DNS query module, including:
> 
>  (1) Use 'negative' instead of '-ve' in the documentation.
> 
>  (2) Mark the kdoc comment with '/**' on dns_query().
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks, David.


> ---
> 
>  Documentation/networking/dns_resolver.txt |    6 +++---
>  net/dns_resolver/dns_query.c              |    2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/networking/dns_resolver.txt b/Documentation/networking/dns_resolver.txt
> index d8e0ce1..aefd1e6 100644
> --- a/Documentation/networking/dns_resolver.txt
> +++ b/Documentation/networking/dns_resolver.txt
> @@ -96,9 +96,9 @@ implemented in the module can be called after doing:
>       for the default query type it is just a list of comma-separated IPv4 and
>       IPv6 addresses.  The caller must free the result.
>  
> -     The length of the result string is returned on success, and a -ve error
> -     code is returned otherwise.  -EKEYREJECTED will be returned if the DNS
> -     lookup failed.
> +     The length of the result string is returned on success, and a negative
> +     error code is returned otherwise.  -EKEYREJECTED will be returned if the
> +     DNS lookup failed.
>  
>       If _expiry is non-NULL, the expiry time (TTL) of the result will be
>       returned also.
> diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
> index b33e1f7..03d5255 100644
> --- a/net/dns_resolver/dns_query.c
> +++ b/net/dns_resolver/dns_query.c
> @@ -45,7 +45,7 @@
>  
>  #include "internal.h"
>  
> -/*
> +/**
>   * dns_query - Query the DNS
>   * @type: Query type (or NULL for straight host->IP lookup)
>   * @name: Name to look up
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
