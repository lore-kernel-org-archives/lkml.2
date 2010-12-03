Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416Ab0LCLHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 06:07:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:49669 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757235Ab0LCLHX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 06:07:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,292,1288594800"; 
   d="scan'208";a="683551600"
From: "Struk, Tadeusz" <tadeusz.struk@intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "O Mahony, Aidan" <aidan.o.mahony@intel.com>,
        "Paoloni, Gabriele" <gabriele.paoloni@intel.com>,
        "Hoban, Adrian" <adrian.hoban@intel.com>
Date: Fri, 3 Dec 2010 11:05:56 +0000
Subject: RE: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
Thread-Topic: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions
Thread-Index: AcuSiaygPUX36LxyRMCGETsfs2tqhgAT55iQ
Message-ID: <24483BA4C9F69C43A7379639D35543D7C3682C99@irsmsx502.ger.corp.intel.com>
References: <4CC9946D.mailLH511GU0C@intel.com>
 <20101104190405.GA2501@gondor.apana.org.au>
 <20101117172331.3bbec734.akpm@linux-foundation.org>
 <20101118092640.GA9486@gondor.apana.org.au>
 <24483BA4C9F69C43A7379639D35543D7C3450A84@irsmsx502.ger.corp.intel.com>
 <20101202161403.74daae6f.akpm@linux-foundation.org>
 <20101203013021.GA304@gondor.apana.org.au>
In-Reply-To: <20101203013021.GA304@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Herbert and Andrew,
Sorry for delay. We have the patch almost ready. We just want to do some more testing before we send it.
We should be ready to send it out next week. Next Friday (10 Dec) will be worst case date.
Thanks,
Tadeusz
 

-----Original Message-----
From: Herbert Xu [mailto:herbert@gondor.apana.org.au] 
Sent: Friday, December 03, 2010 1:30 AM
To: Andrew Morton
Cc: Struk, Tadeusz; linux-kernel@vger.kernel.org; linux-crypto@vger.kernel.org; O Mahony, Aidan; Paoloni, Gabriele; Hoban, Adrian
Subject: Re: [PATCH 2/3] RFC4106 AES-GCM Driver Using Intel New Instructions

On Thu, Dec 02, 2010 at 04:14:03PM -0800, Andrew Morton wrote:
>
> > > Tadeusz, could you please make an incremental patch that converts
> > > all the pshufb instructions to macros?
> > > 
> >
> > Will do.
> > Tadeusz
> > 
> 
> (top-posting repaired)
> 
> (busted attribution/quoting repaired)
> 
> Current mainline still has this failure.

Tadeusz, can you update us on your progress on this?

Andrew, I'll just back this out if it doesn't get resolved.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--------------------------------------------------------------
Intel Shannon Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263
Business address: Dromore House, East Park, Shannon, Co. Clare

This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). Any review or distribution by others is strictly prohibited. If you are not the intended recipient, please contact the sender and delete all copies.


