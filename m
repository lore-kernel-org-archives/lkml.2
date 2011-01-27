Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1A0I1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 03:27:23 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53346 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab1A0I1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 03:27:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OwluNg294trP/YlTPDx+0FCSu493zt/fkAM6q5z6/bFgLsLEtIAiVV5NlyH515ZGSl
         5zARGZOsmEUK67ZAJ9/mSThr12wV25TF1jG+0zQnmpyFwBfjzB6QKRbcjoA2CVWffeM7
         Qq5fmcwNcG6JF0pCjV/fcXF40W7W95nKxPebM=
Date: Thu, 27 Jan 2011 10:27:19 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, olofj@chromium.org
Subject: Re: [PATCH] printk: allow setting DEFAULT_MESSAGE_LEVEL via Kconfig
Message-ID: <20110127082718.GA4748@p183.telecom.by>
References: <20110125235700.GR8008@google.com>
 <20110126144910.ce0646ec.akpm@linux-foundation.org>
 <20110126145703.a0f5add5.rdunlap@xenotime.net>
 <20110126151017.ed9e627c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126151017.ed9e627c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 03:10:17PM -0800, Andrew Morton wrote:
> On Wed, 26 Jan 2011 14:57:03 -0800
> Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
> > > I'm a bit surprised that this wasn't already tunable at boot-time
> > > and/or at runtime.
> > 
> > 
> > As WANG Cong replied:
> > 
> > Why? We already have "loglevel=" kernel parameter.
> 
> That's different.
> 
> Mandeep's patch addresses printks which didn't have a facility level. 

For those, we have ignore_loglevel kernel parameter.
