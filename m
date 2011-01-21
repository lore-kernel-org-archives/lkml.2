Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab1AUPhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:37:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:49927 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab1AUPht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:37:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,358,1291622400"; 
   d="scan'208";a="699205190"
From: "Lu, Hongjiu" <hongjiu.lu@intel.com>
To: "Anvin, H Peter" <h.peter.anvin@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 21 Jan 2011 07:37:46 -0800
Subject: RE: Linux 2.6.38-rc1 doesn't boot
Thread-Topic: Linux 2.6.38-rc1 doesn't boot
Thread-Index: Acu5f92bq00plkE7Qwuwsg1b6rUE3gAATPwQ
Message-ID: <9DA5872FEF993D41B7173F58FCF6BE9409F70604@orsmsx504.amr.corp.intel.com>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
	 <20110119073905.GA1652@gentoo.trippels.de>
	 <20110119074902.GA1670@gentoo.trippels.de>
	 <1295424766.1949.879.camel@sli10-conroe> <4D36A759.60704@intel.com>
	 <20110119090904.GA4927@elte.hu> <1295489286.1949.882.camel@sli10-conroe>
	 <20110120112541.GA23661@elte.hu>
	 <ADDEBCD9C145E542A8688C29F1FBDCB9C915F59E@orsmsx502.amr.corp.intel.com>
 <1295594339.1949.936.camel@sli10-conroe> <4D39A621.7080007@intel.com>
In-Reply-To: <4D39A621.7080007@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0LFbwVN011780

Or we can just ban those broken linker versions.

H.J.


> -----Original Message-----
> From: Anvin, H Peter
> Sent: Friday, January 21, 2011 7:29 AM
> To: Li, Shaohua
> Cc: Ingo Molnar; Markus Trippelsdorf; Lu, Hongjiu; Linus Torvalds;
> Linux Kernel Mailing List; Sam Ravnborg
> Subject: Re: Linux 2.6.38-rc1 doesn't boot
> 
> On 01/20/2011 11:18 PM, Li, Shaohua wrote:
> >  		*(.jiffies)
> >  	}
> >  	jiffies = VVIRT(.jiffies);
> > +	jiffies_64 = jiffies;
> >
> 
> OK, this is just messed up.  If we need jiffies in a special section
> then we should declare it as such (see __jiffy_data), but it's not
> clear
> to me why we would.  This seems like hack upon hack.
> 
> However, I suspect we may want to put jiffies into a .S file, and that
> .S file needs to take into account architectures which need underscore
> prefixes (which really sucks to have in ELF and is a major fail on
> those
> ABI designers...)
> 
> 	-hpa
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
