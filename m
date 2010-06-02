Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab0FBRk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 13:40:59 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:31207 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab0FBRk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 13:40:57 -0400
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jun 2010 13:40:57 EDT
Message-ID: <4C069551.8020106@hp.com>
Date: Wed, 02 Jun 2010 13:30:57 -0400
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Sridhar Samudrala <sri@us.ibm.com>,
       linux-sctp@vger.kernel.org
Subject: Re: [PATCH 21/21] net/sctp/protocol.c: Remove unnecessary kmalloc
 casts
References: <cover.1275360951.git.joe@perches.com> <789ef255b7c046dd11fad6ca8c057354b6306c7f.1275360951.git.joe@perches.com>
In-Reply-To: <789ef255b7c046dd11fad6ca8c057354b6306c7f.1275360951.git.joe@perches.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACK

-vlad

Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  net/sctp/protocol.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index 1827498..fef38be 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -1216,8 +1216,7 @@ SCTP_STATIC __init int sctp_init(void)
>  
>  	/* Allocate and initialize the endpoint hash table.  */
>  	sctp_ep_hashsize = 64;
> -	sctp_ep_hashtable = (struct sctp_hashbucket *)
> -		kmalloc(64 * sizeof(struct sctp_hashbucket), GFP_KERNEL);
> +	sctp_ep_hashtable = kmalloc(64 * sizeof(struct sctp_hashbucket), GFP_KERNEL);
>  	if (!sctp_ep_hashtable) {
>  		printk(KERN_ERR "SCTP: Failed endpoint_hash alloc.\n");
>  		status = -ENOMEM;
