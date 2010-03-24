Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab0CXH3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 03:29:24 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48560 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab0CXH3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 03:29:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vkSimxleleOH81+Q2LhGjokgXHtcrR01f8pO0Bk7kRbRL5zLTHnRnEwqBfYZMlcRE5
         l3p0mc7nu6YjDJRlvt42FYaVgoSqsyEmUF6mO6GNstSXG2da+NAUWPjFu+zZwoTMBwPE
         dKPF4yim+JdiHT3t/ObLq01l9uZSdr39JjaPs=
Date: Wed, 24 Mar 2010 00:29:17 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 24
Message-ID: <20100324072916.GA4254@core.coreip.homeip.net>
References: <20100324161746.85edc5a3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324161746.85edc5a3.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 04:17:46PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20100323:
> 
> Dropped tree: tmio-mmc (long unresolved conflicts and unable to fetch)
> 
> My fixes tree contains:
> 	a patch for a pktcdvd build error from Arnd Bergmann
> 	a revert of the commit that broke virtual consoles on PowerPC
> 
> The input tree still has its build failure for which I reverted a commit.
> 

Should be fixed now.

-- 
Dmitry
