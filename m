Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab2BHQP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 11:15:27 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:64152 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2BHQPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 11:15:25 -0500
X-Greylist: delayed 1589 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Feb 2012 11:15:24 EST
Date: Wed, 8 Feb 2012 15:48:51 +0000 (UTC)
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: David Howells <dhowells@redhat.com>
cc: jmorris@namei.org, keyrings@linux-nfs.org, linux-nfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-api@vger.kernel.org,
        libc-alpha@sourceware.org
Subject: Re: [PATCH 1/2] Define ENOAUTHSERVICE to indicate "Authentication
 service unavailable"
In-Reply-To: <20120208122905.8902.65762.stgit@warthog.procyon.org.uk>
Message-ID: <Pine.LNX.4.64.1202081546240.8820@digraph.polyomino.org.uk>
References: <20120208122905.8902.65762.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 08 Feb 2012 15:48:53.0461 (UTC) FILETIME=[28AAB850:01CCE679]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Feb 2012, David Howells wrote:

>  #define ERFKILL		132	/* Operation not possible due to RF-kill */
> +#define	ENOAUTHSERVICE	133	/* Authentication service not available */
>  
>  #define EHWPOISON	133	/* Memory page has hardware error */

Defining the new error to have the same value as EHWPOISON seems rather 
odd....

-- 
Joseph S. Myers
joseph@codesourcery.com
