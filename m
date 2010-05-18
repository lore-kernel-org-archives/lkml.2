Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0ERXBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 19:01:15 -0400
Received: from www.tglx.de ([62.245.132.106]:50684 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490Ab0ERXBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 19:01:11 -0400
Date: Wed, 19 May 2010 01:00:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: jacob pan <jacob.jun.pan@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alek Du <alek.du@intel.com>,
       Alan Cox <alan@linux.intel.com>, Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH 2/2] v4 x86/mrst: add more timer config options
In-Reply-To: <20100518155736.00007d03@unknown>
Message-ID: <alpine.LFD.2.00.1005190058330.3368@localhost.localdomain>
References: <1274184166-17242-1-git-send-email-jacob.jun.pan@linux.intel.com> <1274184166-17242-3-git-send-email-jacob.jun.pan@linux.intel.com> <alpine.LFD.2.00.1005182240480.3368@localhost.localdomain> <20100518155736.00007d03@unknown>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010, jacob pan wrote:

> 
> >>  
> >> +/**
> >
> >  Do not use kerneldoc /** opener from plain comments. Randy
> >  complained about that yesterday already
> >
> I missed randy's comment at the end. sorry. I admit I did not know kernel-doc
> before that.
> 
> 		if (mrst_identify_cpu() == MRST_CPU_CHIP_PENWELL) {
> >
> >  Why do you want to pin that on PENWELL and not on ARAT ? If you
> >  check ARAT, you have coverd all next gen cpus as well.
> 
> I did try ARAT first but ARAT is not available at this point. the add-on cpu
> features are set later.

Hmm, I don't see a reason why we don't to the readout of the extra
features right away. I might be missing something really important
though :) hpa ?????

Thanks,

	tglx


