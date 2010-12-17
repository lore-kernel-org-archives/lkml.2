Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab0LQTuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:50:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab0LQTux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:50:53 -0500
Date: Fri, 17 Dec 2010 14:50:35 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Uvarov <muvarov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
Message-ID: <20101217195035.GE14502@redhat.com>
References: <20101215103954.GA2243@redhat.com>
 <4D09958D.2040907@kernel.org>
 <4D0AD976.3020504@zytor.com>
 <3C6B7683-9CDC-4C4A-A32A-56227DE01387@kernel.org>
 <20101217170146.GC9568@redhat.com>
 <4D0BA45A.7020402@zytor.com>
 <20101217180242.GB12425@redhat.com>
 <4D0BAA24.3080801@kernel.org>
 <4D0BBC55.4010207@zytor.com>
 <4D0BBE00.3010602@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0BBE00.3010602@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 11:46:08AM -0800, Yinghai Lu wrote:
> On 12/17/2010 11:39 AM, H. Peter Anvin wrote:
> > On 12/17/2010 10:21 AM, Yinghai Lu wrote:
> >>>>
> >>>> Do we have actual testing for how high the 64-bit kernel will load?
> >>>
> >>> I will do some experiments on my box today and let you know.
> >>
> >> if bzImage is used, it is 896M.
> >>
> > 
> > Why?  896 MiB is a 32-bit kernel limitation which doesn't have anything
> > to do with the bzImage format.
> > 
> > So unless there is something going on here, I suspect you're just plain
> > flat wrong.
> 
> kexec-tools have some checking when it loads bzImage.
> 

Yinghai,

I think x86_64 might have just inherited the settings of 32bit without
giving it too much of thought. At that point of time nobody bothered
to load the kernel from high addresses. So these might be artificial
limits.

Thanks
Vivek
