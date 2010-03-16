Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951Ab0CPRUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:20:21 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:25167 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759919Ab0CPRUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:20:19 -0400
X-IronPort-AV: E=Sophos;i="4.49,651,1262581200"; 
   d="scan'208";a="88339134"
Subject: Re: [Xen-devel] [PATCH][v9 4/6] xen/hvm: Xen PV extension of HVM
 initialization
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Sheng Yang <sheng@linux.intel.com>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>
In-Reply-To: <4B9FBBEA.2060508@goop.org>
References: <1268362647-5317-1-git-send-email-sheng@linux.intel.com>
	 <alpine.DEB.2.00.1003151108151.27222@kaball-desktop>
	 <4B9EBBEE.9020107@goop.org> <201003160951.48973.sheng@linux.intel.com>
	 <4B9FBBEA.2060508@goop.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 16 Mar 2010 17:20:10 +0000
Message-ID: <1268760010.10129.31253.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 17:12 +0000, Jeremy Fitzhardinge wrote:
> If we need a new vcpuop to make it work 
> properly anyway (set tsc offset), then the presence of that should be
> a 
> good indicator.  In other words, make it depend on its actual fixed 
> pre-reqs, rather than a specific flag for the feature. 

I don't think a new hypercall is required. Xen should simply pre-account
for the TSC offset which HVM guests are subject to in
__update_vcpu_system_time.

Ian.

