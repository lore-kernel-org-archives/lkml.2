Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab2ISEAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 00:00:37 -0400
Received: from mail.digium.com ([216.207.245.2]:49563 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab2ISEAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 00:00:35 -0400
Date: Tue, 18 Sep 2012 22:53:06 -0500
From: Shaun Ruffell <sruffell@digium.com>
To: Xie Shaohui-B21989 <B21989@freescale.com>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "avorontsov@mvista.com" <avorontsov@mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: Re: [PATCH] edac/85xx: fix error handle of mpc85xx_mc_err_probe
Message-ID: <20120919035306.GF24873@digium.com>
References: <1347533729-5893-1-git-send-email-Shaohui.Xie@freescale.com>
 <20120914182137.GD18672@digium.com>
 <ED492CCEAF882048BC2237DE806547C9079E171E@039-SN2MPN1-012.039d.mgd.msft.net>
 <20120919030438.GE24873@digium.com>
 <ED492CCEAF882048BC2237DE806547C9079E3F3D@039-SN2MPN1-012.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ED492CCEAF882048BC2237DE806547C9079E3F3D@039-SN2MPN1-012.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 03:43:35AM +0000, Xie Shaohui-B21989 wrote:
> > On Mon, Sep 17, 2012 at 10:32:59AM +0000, Xie Shaohui-B21989 wrote:
> > >
> > > BTW: seems you are using a different kernel tree with mine.
> > 
> > On the chance that I missing something important: Why do you say
> > I was running a different kernel tree? I was against 3.6-rc2
> > when I original hit the problem.
>
> [S.H] I'm using 3.6-rc4, and some codes in your patch I did not
> find them in 3.6-rc4.

Is it because there were three patches in the series?

  [1/3] https://lkml.org/lkml/2012/9/14/473
  [2/3] https://lkml.org/lkml/2012/9/14/469
  [3/3] https://lkml.org/lkml/2012/9/14/474

They are also the last three commits on my edac_debug_v2 branch
here, which is on top of 3.6-rc6:

https://github.com/sruffell/linux/commits/edac_debug_v2/

Cheers,
Shaun
