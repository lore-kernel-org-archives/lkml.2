Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000Ab0EZAZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 20:25:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:57968 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758506Ab0EZAZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 20:25:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,300,1272870000"; 
   d="scan'208";a="624824147"
Subject: Re: [stable] Boot failure with 2.6.27.46 on Xeon E5620 (Westmere
 EP)
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Greg KH <greg@kroah.com>
Cc: =?UTF-8?Q?S=2E=C3=87a=C4=9Flar?= Onur <caglar@CS.Princeton.EDU>,
       "stable@kernel.org" <stable@kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Song, Youquan" <youquan.song@intel.com>
In-Reply-To: <20100525205123.GA14993@kroah.com>
References: <000954C6-B4AC-4FD8-BA3B-C3B199C7607F@CS.Princeton.EDU>
	 <20100525155307.GA7453@kroah.com>
	 <620C3556-2708-4704-90F3-37DDEF1A404E@CS.Princeton.EDU>
	 <20100525205123.GA14993@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corp
Date: Tue, 25 May 2010 17:24:11 -0700
Message-Id: <1274833451.2892.574.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 13:51 -0700, Greg KH wrote:
> On Tue, May 25, 2010 at 04:32:16PM -0400, "S.Çağlar Onur" wrote:
> > Hi Greg,
> > 
> > On May 25, 2010, at 11:53 AM, Greg KH wrote:
> > 
> > > On Tue, May 25, 2010 at 11:10:28AM -0400, "S.Çağlar Onur" wrote:
> > >> Hi,
> > >> 
> > >> We are observing boot failures [1] & [2] on some of our servers (Dell
> > >> r410) with 2.6.27-stable kernels. I found following commit in upstream
> > >> tree via a quick search (but I haven't tried it yet) so I don't know
> > >> whether I'm on the right track or not. 
> > >> 
> > >> Please let me know if anything else is needed...
> > > 
> > > Has any .27 kernel worked on these machines?  If so, can you narrow it
> > > down to the patch that caused the problem?
> > 
> > I don't think any .27 kernel worked on those machines before. But in
> > any case I'll try (I don't have a physical access to those machines as
> > they are located in China) an older .27 release to see.
> 
> Ok, so it isn't a regression, which is what I want to know.
> 
> New hardware like this, probably will only work on newer kernel
> versions, so please use those instead :)

I can't think of any known issues in 2.6.27 that can lead to this kind
of boot failure on WSM-EP. Caglar, It will be nice if you can do git
bisect between working and non-working kernels.

thanks,
suresh

