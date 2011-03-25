Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1CYWCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 18:02:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59337 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab1CYWCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 18:02:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ulckdbRSLq3c2vRmoK3a55lCrNEuiCZFAsfnLpcphTc1gJtxOqBVn7ox3vvy7FLG9V
         yWP35IqpysNmIpvJcjwQFsT7PNpLMN9gGcia+CN3nzeiSL5T3f7dvhltycu8BbPqJvor
         pN7K5RyPUCb3c2ODuPZiaLSVIOdH6aXkS59TE=
Date: Fri, 25 Mar 2011 23:00:41 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] docs: update the development process document
Message-ID: <20110325220041.GA17009@joi.lan>
References: <20110325123031.45b6a217@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110325123031.45b6a217@bike.lwn.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 12:30:31PM -0600, Jonathan Corbet wrote:
> @@ -193,8 +199,8 @@ involved.
>  2.3: HOW PATCHES GET INTO THE KERNEL
>  
>  There is exactly one person who can merge patches into the mainline kernel
> -repository: Linus Torvalds.  But, of the over 12,000 patches which went
> -into the 2.6.25 kernel, only 250 (around 2%) were directly chosen by Linus
> +repository: Linus Torvalds.  But, of the over 9,500 patches which went
> +into the 2.6.28 kernel, only 112 (around 1.3%) were directly chosen by Linus

I think you wanted to write "2.6.38" instead of "2.6.28" - numbers look like
they were taken from .38 cycle.

Marcin
