Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab1FIMZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 08:25:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757235Ab1FIMZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:25:39 -0400
Date: Thu, 9 Jun 2011 14:25:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [TRIVIAL PATCH v2] treewide: Convert uses of struct resource to
 resource_size(ptr)
In-Reply-To: <1307482186.22272.29.camel@Joe-Laptop>
Message-ID: <alpine.LNX.2.00.1106091423400.22872@pobox.suse.cz>
References: <201106061349.00474.hartleys@visionengravers.com>  <1307397174.4994.26.camel@Joe-Laptop>  <ADE657CA350FB648AAC2C43247A983F001F3820B7C78@AUSP01VMBX24.collaborationhost.net>  <1307408678.4994.46.camel@Joe-Laptop> 
 <ADE657CA350FB648AAC2C43247A983F001F3820B7EB4@AUSP01VMBX24.collaborationhost.net> <1307482186.22272.29.camel@Joe-Laptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jun 2011, Joe Perches wrote:

> Several fixes as well where the +1 was missing.
> 
> Done via coccinelle scripts like:
> 
> @@
> struct resource *ptr;
> @@
> 
> - ptr->end - ptr->start + 1
> + resource_size(ptr)
> 
> and some grep and typing.
> 
> Mostly uncompiled, no cross-compilers.
> 
> Some checkpatch complaints cheerfully ignored.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Hi Joe,

thanks a lot for the patch. I will be happily taking it. However it seems 
like some of the files are going away/have been moved in -next. Could you 
please respin on top of what is still applicable on -next and resend? 

Thanks,

-- 
Jiri Kosina
SUSE Labs
