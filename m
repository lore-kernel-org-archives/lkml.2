Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365Ab0J0DAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 23:00:48 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62485 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab0J0DAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 23:00:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vZkrxmu6JjIZ9mcvCBuK1xv74TeG1BBJ4qa/XYnSxTGlo3eY0umg7csghUvCrAj42/
         fOxD+Id/M0PhSHM/+5nEBDwFLGRDU92AfcD+985UUytlb2bu/8GzpLiR5bnlwhZqN9V8
         NONnBhBd4TrvNOoDOG5FJSg9fmRM0bw7U1JKw=
Date: Tue, 26 Oct 2010 20:00:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] drivers/input/serio/i8042: Use pr_<level>, pr_fmt.
 Fix dbg and __FILE__ use
Message-ID: <20101027030037.GA19202@core.coreip.homeip.net>
References: <cover.1288059486.git.joe@perches.com>
 <20101026155028.GA13097@core.coreip.homeip.net>
 <1288135531.4145.59.camel@Joe-Laptop>
 <201010261740.13566.dmitry.torokhov@gmail.com>
 <1288140416.4145.76.camel@Joe-Laptop>
 <BFA186FD-32F7-4E1A-9193-CA1575248B73@gmail.com>
 <1288141825.4145.83.camel@Joe-Laptop>
 <4E27039C-DE6B-4C90-ADC5-68D3B30F75E6@gmail.com>
 <1288143345.4145.90.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288143345.4145.90.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 06:35:45PM -0700, Joe Perches wrote:
> On Tue, 2010-10-26 at 18:28 -0700, Dmitry Torokhov wrote:
> > On Oct 26, 2010, at 6:10 PM, Joe Perches <joe@perches.com> wrote:
> > > I think 2 defects in 16 uses is a pretty high error rate.
> > But how not adding /n is it much better than having it if
> > some later change will forget to add it to the message?
> 
> Adding \n is the default kernel style.
> 
> USB uses a similar dbg macro with a relatively
> high error rate.
> 
> I fixed some in this commit below awhile ago,
> but these keep creeping back in, so they _are_
> error prone in actual use.
> 

OK, fair enough.

Thanks.

-- 
Dmitry
