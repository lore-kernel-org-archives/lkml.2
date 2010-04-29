Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934126Ab0D3SkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:40:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:22676 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933085Ab0D3RV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:21:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,296,1270450800"; 
   d="scan'208";a="271612799"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: David Woodhouse <dwmw2@infradead.org>, Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Ming Lei <tom.leiming@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 29 Apr 2010 21:03:25 +0300
Subject: RE: [PATCH] firmware_class: fix memory leak - free allocated pages
Thread-Topic: [PATCH] firmware_class: fix memory leak - free allocated pages
Thread-Index: AcrnxPDw19njp1VAT+WKHWevD81M2wAARQsg
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F04016E6B6959@hasmsx504.ger.corp.intel.com>
References: <1272544821-22466-1-git-send-email-tomas.winkler@intel.com>
	 <20100429145425.GA3703@suse.de>
 <1272563622.3367.4116.camel@macbook.infradead.org>
In-Reply-To: <1272563622.3367.4116.camel@macbook.infradead.org>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o3UIeomE008957



> -----Original Message-----
> From: David Woodhouse [mailto:dwmw2@infradead.org]
> Sent: Thursday, April 29, 2010 8:54 PM
> To: Greg KH
> Cc: Winkler, Tomas; linux-kernel@vger.kernel.org; Johannes Berg; Ming Lei;
> Catalin Marinas
> Subject: Re: [PATCH] firmware_class: fix memory leak - free allocated pages
> 
> On Thu, 2010-04-29 at 15:54 +0100, Greg KH wrote:
> > On Thu, Apr 29, 2010 at 03:40:21PM +0300, Tomas Winkler wrote:
> > > fix memory leak introduced by 6e03a201bbe patch:
> > >  firmware: speed up request_firmware()
> >
> > Who originally wrote this patch, Kay?
> 
> It's kind of a joint effort. I think it's probably mine by a fairly
> narrow majority.
> 
> >  If so, Tomas, please put a "From:" line at the top of the patch with
> > the author's name so we get it right when commiting it.
> 
> And don't make up Signed-off-by lines. Although you can have that one of
> mine now you've got it (since you've actually tested it).

I added firmware_free_data function to the original patch, would you mind to review it, please.

Thanks
Tomas
> 
> --
> David Woodhouse                            Open Source Technology Centre
> David.Woodhouse@intel.com                              Intel Corporation

---------------------------------------------------------------------Intel Israel (74) Limited
This e-mail and any attachments may contain confidential material forthe sole use of the intended recipient(s). Any review or distributionby others is strictly prohibited. If you are not the intendedrecipient, please contact the sender and delete all copies.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
