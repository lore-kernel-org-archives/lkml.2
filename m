Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab0GIGKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 02:10:13 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:43057 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab0GIGKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 02:10:11 -0400
Date: Fri, 9 Jul 2010 15:10:07 +0900
From: Simon Horman <horms@verge.net.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Matthew Wilcox <matthew@wil.cx>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       macro@linux-mips.org, kamezawa.hiroyu@jp.fujitsu.com,
       eike-kernel@sf-tec.de
Subject: Re: [PATCH 1/2] x86: ioremap: fix wrong physical address handling
Message-ID: <20100709061007.GD20370@verge.net.au>
References: <4C197A49.6020400@jp.fujitsu.com>
 <4C197A9E.5040509@jp.fujitsu.com>
 <20100617025052.GH9298@parisc-linux.org>
 <4C19A2EE.2010203@zytor.com>
 <4C19AABA.8000706@jp.fujitsu.com>
 <4C19BA9A.4010300@zytor.com>
 <4C19EC57.3000409@goop.org>
 <20100709042421.GB2951@verge.net.au>
 <4C36B494.6060801@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C36B494.6060801@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 10:33:08PM -0700, Jeremy Fitzhardinge wrote:
> On 07/08/2010 09:24 PM, Simon Horman wrote:
> >> I think it would be a pretty large change.  From the Xen's perspective,
> >> any machine even approximately approaching the 2^44 limit will be
> >> capable of running Xen guests in hvm mode, so PV isn't really a concern.
> >>     
> > Hi Jeremy,
> >
> > Is the implication of that statement that HVM is preferred where
> > supported by HW?
> >   
> 
> I wouldn't go that far; the PV vs HVM choice is pretty complex, and
> depends on what your workload is and what hardware you have available. 
> All I meant was what I said: that if you're running on a machine with a
> large amount of memory, then you should run your 32-bit domains as HVM
> rather than PV.  Though Xen could easily keep domains limited to memory
> that they can actually use (it already does this, in fact).

Hi Jeremy,

thanks for the clarification.
