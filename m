Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab2JBBIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 21:08:15 -0400
Received: from mx2.netapp.com ([216.240.18.37]:31773 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab2JBBIL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 21:08:11 -0400
X-IronPort-AV: E=Sophos;i="4.80,520,1344236400"; 
   d="scan'208";a="696342408"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Trond Myklebust <trond.myklebust@fys.uio.no>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: build failure after merge of the nfs tree
Thread-Topic: linux-next: build failure after merge of the nfs tree
Thread-Index: AQHNoDn1kxosC68qYU+fhaFfmC0VMpelNATg
Date: Tue, 2 Oct 2012 01:08:09 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA908FFCB41@SACEXCMBX04-PRD.hq.netapp.com>
References: <20121002103907.e43f5bb1cc9e6b85b3a51ef8@canb.auug.org.au>
In-Reply-To: <20121002103907.e43f5bb1cc9e6b85b3a51ef8@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.53]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Stephen Rothwell
> Sent: Monday, October 01, 2012 8:39 PM
> To: Trond Myklebust
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: linux-next: build failure after merge of the nfs tree
> 
> Hi Trond,
> 
> After merging the nfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/nfs/callback.c: In function 'nfs_minorversion_callback_svc_setup':
> fs/nfs/callback.c:206:21: error: 'ENOTSUP' undeclared (first use in this
> function)
> 
> Caused by commit 141e1f553b6e ("NFSv4: Fix the minor version callback
> channel startup").
> 

Hi Stephen,

Thanks! We've already fixed this issue and pushed out a new tree...

Cheers
  Trond
