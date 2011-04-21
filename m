Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab1DUVmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:42:46 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:57941 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab1DUVmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:42:45 -0400
Date: Thu, 21 Apr 2011 23:42:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Dave Jones <davej@redhat.com>, David Daney <ddaney@caviumnetworks.com>,
        Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        BorislavPetkov <bp@alien8.de>
Subject: Re: annoying new gcc 4.6.0 warnings.
Message-ID: <20110421214243.GA10349@merkur.ravnborg.org>
References: <BANLkTi=srdq69ZG8pWbzWOZLX5KX48DcbQ@mail.gmail.com> <4DB087EC.1010205@caviumnetworks.com> <1303415086.24766.84.camel@Joe-Laptop> <20110421195801.GA15126@redhat.com> <20110421200836.GA31709@merkur.ravnborg.org> <20110421202713.GA19425@redhat.com> <4DB09590.1040709@caviumnetworks.com> <20110421204549.GA20508@redhat.com> <20110421205612.GA4541@merkur.ravnborg.org> <20110421212812.GA26680@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421212812.GA26680@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 05:28:13PM -0400, Dave Jones wrote:
> On Thu, Apr 21, 2011 at 10:56:12PM +0200, Sam Ravnborg wrote:
>  > 
>  > Seems soo. It semi works now.
>  > "make W=1" is broken for reasons that is not related to this patch - will submit
>  > a fix in a minute for that.
>  > 
>  > So you can add:
>  > Acked-by: Sam Ravnborg <sam@ravnborg.org>
>  > Tested-by: Sam Ravnborg <sam@ravnborg.org>
>  > 
>  > on the patch.
>  > 
>  > And if you really want to make me happy then you add a comment about _why_
>  > we disable the warning.
> 
> ok, last time for reals.
Thanks - I'm happy now :-)

	Sam
