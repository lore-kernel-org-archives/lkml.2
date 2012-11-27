Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab2K0VNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 16:13:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21144 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab2K0VNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 16:13:21 -0500
Date: Tue, 27 Nov 2012 16:12:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Rientjes <rientjes@google.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, andi@firstfloor.org,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, hannes@cmpxchg.org,
        yinghan@google.com, dan.magenheimer@oracle.com
Subject: Re: [PATCH 1/1] mm: Export a function to get vm committed memory
Message-ID: <20121127211206.GA10391@phenom.dumpdata.com>
References: <1352818957-9229-1-git-send-email-kys@microsoft.com>
 <alpine.DEB.2.00.1211131307090.5164@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211131307090.5164@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 01:07:30PM -0800, David Rientjes wrote:
> On Tue, 13 Nov 2012, K. Y. Srinivasan wrote:
> 
> > It will be useful to be able to access global memory commitment from device
> > drivers. On the Hyper-V platform, the host has a policy engine to balance
> > the available physical memory amongst all competing virtual machines
> > hosted on a given node. This policy engine is driven by a number of metrics
> > including the memory commitment reported by the guests. The balloon driver
> > for Linux on Hyper-V will use this function to retrieve guest memory commitment.
> > This function is also used in Xen self ballooning code.
> > 
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> Acked-by: David Rientjes <rientjes@google.com>

I am bit late to this party - and back from vacation - so not sure if this
is merged in or not. Either way:

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> on the drivers/xen* side.
