Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936279Ab0CONnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 09:43:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35638 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab0CONnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 09:43:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B9E396E.8050606@s5r6.in-berlin.de>
Date: Mon, 15 Mar 2010 14:43:10 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@osdl.org, akpm@linux-foundation.org, sgruszka@redhat.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Document Linux's circular buffering capabilities
References: <4B9B5A37.2010206@s5r6.in-berlin.de> <4B9A6033.8010705@s5r6.in-berlin.de> <20100311172055.7328.51353.stgit@warthog.procyon.org.uk> <18180.1268437268@redhat.com> <30121.1268656565@redhat.com>
In-Reply-To: <30121.1268656565@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> How about adding a bit:
> 
>  Note the use of ACCESS_ONCE() in both algorithms to read the opposition index.
>  This prevents the compiler from discarding and reloading its cached value -
> -which some compilers will do across smp_read_barrier_depends().
> +which some compilers will do across smp_read_barrier_depends().  This isn't
> +strictly needed if you can be sure that the opposition index will _only_ be
> +used the once.

Yes, thanks.  (The last "the" is superfluous.)
-- 
Stefan Richter
-=====-==-=- --== -====
http://arcgraph.de/sr/
