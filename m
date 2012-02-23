Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab2BWXTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:19:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:59414 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab2BWXTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:19:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="111356679"
Subject: Re: [PATCH 0/5] i387: stable kernel backport
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
        Raphael Prevost <raphael@buro.asia>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 23 Feb 2012 15:19:20 -0800
In-Reply-To: <4F46C92B.4090508@zytor.com>
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org>
	 <20120222211928.GA4448@kroah.com>
	 <CA+55aFz0pOO6j9s3Gs2UJLM4zm8SuPgi5iUiVAaPCp9Xh2Pvjw@mail.gmail.com>
	 <20120222213253.GA25150@kroah.com> <20120223200905.GA5475@kroah.com>
	 <4F46A1C4.90506@zytor.com> <20120223204832.GA30322@kroah.com>
	 <4F46A6EC.8050804@zytor.com> <20120223211016.GA16275@kroah.com>
	 <4F46C63C.4040602@zytor.com> <20120223231605.GA15329@kroah.com>
	 <4F46C92B.4090508@zytor.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1330039160.29790.376.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 15:18 -0800, H. Peter Anvin wrote:
> On 02/23/2012 03:16 PM, Greg Kroah-Hartman wrote:
> > 
> > And a "clean" 3.2.7 doesn't have that problem?
> > 
> > Does the same thing happen in Linus's tree at the moment?
> > 
> 
> Clean 3.2.7 I don't think has that problem, although of course when I
> run the stress test it fails on other ways so it's hard to 100% rule out.

Perhaps you can check the clean 3.2.7 kernel with AES-NI disabled?

thanks,
suresh

> 
> Linus' tree doesn't have that problems.
> 
> 	-hpa
> 
> 


