Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab0ELUxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 16:53:53 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:36959 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab0ELUxv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 16:53:51 -0400
X-IronPort-AV: E=Sophos;i="4.53,217,1272859200"; 
   d="scan'208";a="16561012"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 May 2010 21:53:37 +0100
Subject: RE: [PATCH -mmotm] misc: fix ad525X_dpot build
Thread-Topic: [PATCH -mmotm] misc: fix ad525X_dpot build
Thread-Index: AcryE0fn23NswOLiR0C2JjpSoMwk/QAARNtA
Message-ID: <544AC56F16B56944AEC3BD4E3D5917712E568FBD9E@LIMKCMBX1.ad.analog.com>
References: <201005120149.o4C1n7P4002637@imap1.linux-foundation.org>
 <20100512133915.5af0ab5e.randy.dunlap@oracle.com>
In-Reply-To: <20100512133915.5af0ab5e.randy.dunlap@oracle.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote on 2010-05-12:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Add slab.h to fix build:
>
> drivers/misc/ad525x_dpot.c:609: error: implicit declaration of
> function 'kzalloc'
> drivers/misc/ad525x_dpot.c:609: warning: assignment makes pointer from
> integer without a cast
> drivers/misc/ad525x_dpot.c:656: error: implicit declaration of
> function 'kfree'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Michael Hennerich <michael.hennerich@analog.com>

Acked-by: Michael Hennerich <michael.hennerich@analog.com>

Thanks!

> ---
>  drivers/misc/ad525x_dpot.c |    1 +
>  1 file changed, 1 insertion(+)
> --- mmotm-2010-0511-1820.orig/drivers/misc/ad525x_dpot.c
> +++ mmotm-2010-0511-1820/drivers/misc/ad525x_dpot.c
> @@ -70,6 +70,7 @@
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/delay.h>
> +#include <linux/slab.h>
>
>  #define DRIVER_VERSION                       "0.2"

Greetings,
Michael

Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 4036 Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif


