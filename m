Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab1CYNO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:14:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:30151 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab1CYNO0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:14:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,242,1299484800"; 
   d="scan'208";a="901765309"
From: "Struk, Tadeusz" <tadeusz.struk@intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "O Mahony, Aidan" <aidan.o.mahony@intel.com>,
        "Paoloni, Gabriele" <gabriele.paoloni@intel.com>,
        "Hoban, Adrian" <adrian.hoban@intel.com>
Date: Fri, 25 Mar 2011 13:12:30 +0000
Subject: RE: [PATCH] RFC4106 AES-GCM Driver - fixed problem with packets
	that are not multiple of 64bytes
Thread-Topic: [PATCH] RFC4106 AES-GCM Driver - fixed problem with packets
	that are not multiple of 64bytes
Thread-Index: Acvq7gsq4Z+ZtJmVTIOjeWrxWaUhDgAAEBlc
Message-ID: <24483BA4C9F69C43A7379639D35543D7CEAECC37@irsmsx502.ger.corp.intel.com>
References: <4d77a344.ufBJ2BimO/o2UpKI%tadeusz.struk@intel.com>
 <20110313085636.GB12392@gondor.apana.org.au>
 <24483BA4C9F69C43A7379639D35543D7CEB6A9CE@irsmsx502.ger.corp.intel.com>,<20110325131032.GA12520@gondor.apana.org.au>
In-Reply-To: <20110325131032.GA12520@gondor.apana.org.au>
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

Cool. Thanks
________________________________________
From: Herbert Xu [herbert@gondor.apana.org.au]
Sent: Friday, March 25, 2011 1:10 PM
To: Struk, Tadeusz
Cc: linux-kernel@vger.kernel.org; linux-crypto@vger.kernel.org; O Mahony, Aidan; Paoloni, Gabriele; Hoban, Adrian
Subject: Re: [PATCH] RFC4106 AES-GCM Driver - fixed problem with packets        that are not multiple of 64bytes

On Thu, Mar 24, 2011 at 09:40:28AM +0000, Struk, Tadeusz wrote:
> Hi Herbert,
> This is rather critical as packets of size different than multiple of 64bytes are dropped.
> Do you mind if we push it against stable 2.6.38?

Let me push it to 2.6.39 first :)

I'll push it to stable after that.

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


