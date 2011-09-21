Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab1IUSKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 14:10:24 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43931 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab1IUSKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 14:10:23 -0400
Date: Wed, 21 Sep 2011 14:04:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Christopher S. Aker" <caker@theshore.net>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: kernel BUG at mm/swapfile.c:2527! [was 3.0.0 Xen
 pv guest - BUG: Unable to handle]
Message-ID: <20110921180423.GC17357@phenom.oracle.com>
References: <4E5BA49D.5060800@theshore.net>
 <20110829150734.GB24825@dumpdata.com>
 <1314704744.28989.2.camel@zakaz.uk.xensource.com>
 <4E5E9CDB.3070706@theshore.net>
 <20110906171319.GB29839@dumpdata.com>
 <4E6E2E11.1030602@theshore.net>
 <20110912161127.GB16100@oracle.com>
 <4E724ACD.1050207@theshore.net>
 <4E724F64.5080103@theshore.net>
 <CEE295A1-B386-4A2A-A16C-9AC29DE174E8@theshore.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CEE295A1-B386-4A2A-A16C-9AC29DE174E8@theshore.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E7A2882.00F7:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 18, 2011 at 11:05:33AM -0400, Christopher S. Aker wrote:
> We've discovered a way to reproduce this quite easily!  Fire up a guest, run eatmem with 1M and enough threads to not OOM.

Excellent. Can you also send me your .config to make sure I've the right
knobs set?

> 
> http://www.theshore.net/~caker/uml/patches/utils/eatmem.c
> 
> On a 1G guest: ./eatmem 1M 900
> 
> -Chris
