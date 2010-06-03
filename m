Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab0FCQn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:43:27 -0400
Received: from kroah.org ([198.145.64.141]:38564 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569Ab0FCQn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:43:26 -0400
Date: Thu, 3 Jun 2010 09:40:39 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@CS.Princeton.EDU>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "stable@kernel.org" <stable@kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Song, Youquan" <youquan.song@intel.com>
Subject: Re: [stable] Boot failure with 2.6.27.46 on Xeon E5620 (Westmere
 EP)
Message-ID: <20100603164039.GA7177@kroah.com>
References: <000954C6-B4AC-4FD8-BA3B-C3B199C7607F@CS.Princeton.EDU>
 <20100525155307.GA7453@kroah.com>
 <620C3556-2708-4704-90F3-37DDEF1A404E@CS.Princeton.EDU>
 <20100525205123.GA14993@kroah.com>
 <1274833451.2892.574.camel@sbs-t61.sc.intel.com>
 <2293F1A2-B4DE-4C15-9BAC-CC2E546943D0@CS.Princeton.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2293F1A2-B4DE-4C15-9BAC-CC2E546943D0@CS.Princeton.EDU>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 07:54:29PM -0400, "S.Çağlar Onur" wrote:
> Hi Suresh,
> 
> On May 25, 2010, at 8:24 PM, Suresh Siddha wrote:
> 
> > On Tue, 2010-05-25 at 13:51 -0700, Greg KH wrote:
> >> On Tue, May 25, 2010 at 04:32:16PM -0400, "S.Çağlar Onur" wrote:
> >>> Hi Greg,
> >>> 
> >>> On May 25, 2010, at 11:53 AM, Greg KH wrote:
> >>> 
> >>>> On Tue, May 25, 2010 at 11:10:28AM -0400, "S.Çağlar Onur" wrote:
> >>>>> Hi,
> >>>>> 
> >>>>> We are observing boot failures [1] & [2] on some of our servers (Dell
> >>>>> r410) with 2.6.27-stable kernels. I found following commit in upstream
> >>>>> tree via a quick search (but I haven't tried it yet) so I don't know
> >>>>> whether I'm on the right track or not. 
> >>>>> 
> >>>>> Please let me know if anything else is needed...
> >>>> 
> >>>> Has any .27 kernel worked on these machines?  If so, can you narrow it
> >>>> down to the patch that caused the problem?
> >>> 
> >>> I don't think any .27 kernel worked on those machines before. But in
> >>> any case I'll try (I don't have a physical access to those machines as
> >>> they are located in China) an older .27 release to see.
> >> 
> >> Ok, so it isn't a regression, which is what I want to know.
> >> 
> >> New hardware like this, probably will only work on newer kernel
> >> versions, so please use those instead :)
> > 
> > I can't think of any known issues in 2.6.27 that can lead to this kind
> > of boot failure on WSM-EP. Caglar, It will be nice if you can do git
> > bisect between working and non-working kernels.
> 
> Neither 2.6.27 nor 2.6.27.45 not able to boot those servers, according
> to the on-site admins the boot stuck at following stage[1].

Good, it's not a regression :)

Care to upgrade to a newer kernel version and see if that works?

thanks,

greg k-h
