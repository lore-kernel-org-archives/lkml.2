Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab0EUBXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 21:23:48 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55918 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab0EUBXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 21:23:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jnCIQNEIeE64L910VtCFR7u0dzxADfUGOzjfOln23kGA7sDAv2Or7n3bb5BSG1xgUp
         NMacLaEJowHow4yl3gK4Lw/mhN5RO8nKefYVpvXonjietXeyz81J1yskIW1F6p/ZQwgl
         R3lzJ7fKrsTbvVV+Syt7wlONyFr5ig4xisE4U=
Date: Thu, 20 May 2010 18:23:41 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the kgdb tree
Message-ID: <20100521012340.GA12372@core.coreip.homeip.net>
References: <20100323150443.608ad7f0.sfr@canb.auug.org.au>
 <20100325154307.9cdeae10.sfr@canb.auug.org.au>
 <201003242159.25770.dmitry.torokhov@gmail.com>
 <20100521102158.bf6df441.sfr@canb.auug.org.au>
 <4BF5D8AF.6010408@windriver.com>
 <20100521110938.7bbbbf59.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521110938.7bbbbf59.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 11:09:38AM +1000, Stephen Rothwell wrote:
> Hi Jason,
> 
> On Thu, 20 May 2010 19:49:51 -0500 Jason Wessel <jason.wessel@windriver.com> wrote:
> >
> > Before brute force toggling it, it seems we should check the value and
> > restore it after the execution of handle_sysrq().
> 
> Indeed, at the time I couldn't find an easy way to do that.
> 
> > I'll have to look and see if there is an access function for this.
> 
> Great, thanks.

I would not mind re-exporting sysrq_on() again.

-- 
Dmitry
