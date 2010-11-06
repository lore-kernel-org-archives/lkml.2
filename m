Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab0KFJKp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 05:10:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40920 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab0KFJKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 05:10:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hJ9V9JZVzqW2PX3mCW5nttGleeswq2y42lSXkM4jDcJ/I95CbAznoAeOFD1Nnd3v7I
         hvFaH6nwXGNCm7ZFWjvcHUUItmf/dp7n/wx2mSzIRiaCDyaR/yfuodD7Elg98BvBW0Xt
         8dSHY0dFhCHwv7hcLBixzZ1Lu0zP+bUBF2eEE=
Date: Sat, 6 Nov 2010 12:10:39 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [RFC 1/4]x86: cleanup vector usage
Message-ID: <20101106091039.GB5956@lenovo>
References: <1288766658.23014.114.camel@sli10-conroe> <20101105205516.GB5678@lenovo> <1289022334.2029.3.camel@shli-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289022334.2029.3.camel@shli-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 01:45:34PM +0800, Shaohua Li wrote:
> On Sat, 2010-11-06 at 04:55 +0800, Cyrill Gorcunov wrote:
> > On Wed, Nov 03, 2010 at 02:44:18PM +0800, Shaohua Li wrote:
> > > Cleanup the vector usage and make them continuous if possible.
> > > 
> > > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > > ---
...
> >  Hi Li, this is not just a cleanup -- irq priority were changed as
> > well, but I suppose it's harmless ;)
> I didn't change the local apic timer vector because the comments say the
> priority is important. For others, I do suppose it's harmless.
> 

 ok

  Cyrill
