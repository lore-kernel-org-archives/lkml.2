Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab2E1Les (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 07:34:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:59899 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724Ab2E1Ler convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 07:34:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="148550009"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: Avi Kivity <avi@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "takuya.yoshikawa@gmail.com" <takuya.yoshikawa@gmail.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>,
        "Shan, Haitao" <haitao.shan@intel.com>
Subject: RE: [PATCH v3 4/4] Enabling Access bit when doing memory swapping
Thread-Topic: [PATCH v3 4/4] Enabling Access bit when doing memory swapping
Thread-Index: AQHNN8m33b6njSgvbECbKWBAN0OYjpbXYMXAgAclD4CAAJYpYA==
Date: Mon, 28 May 2012 11:34:43 +0000
Message-ID: <403610A45A2B5242BD291EDAE8B37D300FDCA3AE@SHSMSX102.ccr.corp.intel.com>
References: <1337656995-24964-1-git-send-email-xudong.hao@intel.com>
 <403610A45A2B5242BD291EDAE8B37D300FDC8918@SHSMSX102.ccr.corp.intel.com>
 <4FC35535.90401@redhat.com>
In-Reply-To: <4FC35535.90401@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Avi Kivity [mailto:avi@redhat.com]
> Sent: Monday, May 28, 2012 6:37 PM
> To: Hao, Xudong
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org; mtosatti@redhat.com;
> takuya.yoshikawa@gmail.com; Zhang, Xiantao; Shan, Haitao
> Subject: Re: [PATCH v3 4/4] Enabling Access bit when doing memory swapping
> 
> On 05/23/2012 04:31 PM, Hao, Xudong wrote:
> > Hi, Avi
> >
> > Will these patches be accepted if no other comments?
> >
> 
> I can't see the other patches (use git send-email if possible) but this
> one looks fine.
> 

Ok, I sent other 3 patches just now.

> 
> --
> error compiling committee.c: too many arguments to function
