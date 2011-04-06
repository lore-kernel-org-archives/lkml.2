Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab1DFOJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:09:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:52401 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173Ab1DFOJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:09:51 -0400
Date: Wed, 6 Apr 2011 07:09:49 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] Documentation: fix 3 typos in sysctl/vm.txt
In-Reply-To: <1302081025.1923.26.camel@t41.thuisdomein>
Message-ID: <alpine.LNX.2.00.1104060709430.5855@pobox.suse.cz>
References: <1302081025.1923.26.camel@t41.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Apr 2011, Paul Bolle wrote:

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  Documentation/sysctl/vm.txt |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
> index 30289fa..96f0ee8 100644
> --- a/Documentation/sysctl/vm.txt
> +++ b/Documentation/sysctl/vm.txt
> @@ -481,10 +481,10 @@ the DMA zone.
>  Type(A) is called as "Node" order. Type (B) is "Zone" order.
>  
>  "Node order" orders the zonelists by node, then by zone within each node.
> -Specify "[Nn]ode" for zone order
> +Specify "[Nn]ode" for node order
>  
>  "Zone Order" orders the zonelists by zone type, then by node within each
> -zone.  Specify "[Zz]one"for zode order.
> +zone.  Specify "[Zz]one" for zone order.
>  
>  Specify "[Dd]efault" to request automatic configuration.  Autoconfiguration
>  will select "node" order in following case.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
