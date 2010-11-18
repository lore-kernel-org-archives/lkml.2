Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761Ab0KRWHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 17:07:30 -0500
Received: from kroah.org ([198.145.64.141]:42902 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760751Ab0KRWH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 17:07:28 -0500
Date: Thu, 18 Nov 2010 14:06:39 -0800
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@CS.Princeton.EDU>
Cc: Youquan Song <youquan.song@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "stable@kernel.org" <stable@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>
Subject: Re: [stable] Boot failure with 2.6.27.46 on Xeon E5620 (Westmere
 EP)
Message-ID: <20101118220639.GA956@kroah.com>
References: <000954C6-B4AC-4FD8-BA3B-C3B199C7607F@CS.Princeton.EDU>
 <20100525155307.GA7453@kroah.com>
 <620C3556-2708-4704-90F3-37DDEF1A404E@CS.Princeton.EDU>
 <20100525205123.GA14993@kroah.com>
 <1274833451.2892.574.camel@sbs-t61.sc.intel.com>
 <DD6ACA75-527D-406D-971B-64F042E0ED26@CS.Princeton.EDU>
 <20100526132357.GA26728@youquan-linux.bj.intel.com>
 <E934EC71-FD1D-4750-818F-DDEBA2F68B4D@CS.Princeton.EDU>
 <20101118215429.GA29243@kroah.com>
 <42E89D5B-D2D6-42E5-A218-B538968FF6E5@CS.Princeton.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <42E89D5B-D2D6-42E5-A218-B538968FF6E5@CS.Princeton.EDU>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 04:59:12PM -0500, "S.Çağlar Onur" wrote:
> Hi Greg,
> 
> On Nov 18, 2010, at 4:54 PM, Greg KH wrote:
> 
> > On Thu, Nov 18, 2010 at 04:24:40PM -0500, "S.Çağlar Onur" wrote:
> >> Hi Youquan & Greg,
> >> 
> >> 
> >> On May 26, 2010, at 9:23 AM, Youquan Song wrote:
> >> 
> >>>>> I can't think of any known issues in 2.6.27 that can lead to this kind
> >>>>> of boot failure on WSM-EP. Caglar, It will be nice if you can do git
> >>>>> bisect between working and non-working kernels.
> >>>> 
> >>>> Sure, I'll try to boot those with plain 2.6.27 to see but please note that it's going to be little time consuming. For each one I have to create a custom boot image for them to download and test (a.k.a. don't expect to hear from me soon :))
> >>> 
> >>> Hi Caglar,
> >>> 
> >>> What's the microcode version? Get by "dmesg | grep microcode" if you
> >>> success boot other version of kernel.
> >>> Can you try to disable C-state(C6) in BIOS before your boot 2.6.27?
> >> 
> >> First of all I'm really sorry that it took really long time to reply this mail as I was waiting Dell to send a loaner machine to us. This morning I've got the hardware and following patch solved the boot problem that I was observing, Greg could you consider adding that to 2.6.27-stable tree?
> >> 
> >> commit a0bf284bfedd6dc95bbee7ebf5ccf3b5f753a008
> > 
> > No problem, now queued up.
> 
> Umh please drop that patch for now, seems like I mixed my kernel
> configs and compiled/tested a 64 bit one (by the way 64bit kernel
> boots fine) but 32bit one still fails with the same error. I'll try to
> bisect...

Heh, ok, I'll go drop it now :)

that's what I get for trying to be quick...

thanks,

greg k-h
