Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1LIIs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 03:48:26 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:2515 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1LIIsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 03:48:25 -0500
X-IronPort-AV: E=Sophos;i="4.71,325,1320624000"; 
   d="scan'208";a="9377373"
From: Paul Durrant <Paul.Durrant@citrix.com>
To: annie li <annie.li@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Date: Fri, 9 Dec 2011 08:48:32 +0000
Subject: RE: [PATCH V2 1/2] xen/granttable: Support sub-page grants
Thread-Topic: [PATCH V2 1/2] xen/granttable: Support sub-page grants
Thread-Index: Acy2Tbyz/Cu3TveaSASWwXUnags4QwAAV9Sw
Message-ID: <291EDFCB1E9E224A99088639C4762022B5988E55CE@LONPMAILBOX01.citrite.net>
References: <1323336940-5382-1-git-send-email-annie.li@oracle.com>
	 <1323337048-5426-1-git-send-email-annie.li@oracle.com>
	 <291EDFCB1E9E224A99088639C4762022B5988E5528@LONPMAILBOX01.citrite.net>
	 <4EE08B0D.80504@oracle.com>
	 <291EDFCB1E9E224A99088639C4762022B5988E552D@LONPMAILBOX01.citrite.net>
	 <4EE19A4D.9030500@oracle.com> <4EE1BC7E.3060904@oracle.com>
 <1323419827.20077.3.camel@zakaz.uk.xensource.com>
In-Reply-To: <1323419827.20077.3.camel@zakaz.uk.xensource.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id pB98mX92002957

> -----Original Message-----
> From: Ian Campbell
> Sent: 09 December 2011 08:37
> To: annie li
> Cc: Paul Durrant; xen-devel@lists.xensource.com; linux-
> kernel@vger.kernel.org; konrad.wilk@oracle.com; jeremy@goop.org;
> kurt.hackel@oracle.com
> Subject: Re: [PATCH V2 1/2] xen/granttable: Support sub-page grants
> 
> On Fri, 2011-12-09 at 07:45 +0000, annie li wrote:
> >
> > On 2011-12-9 13:19, annie li wrote:
> > > Hi Paul,
> > >
> > >>>> #define get_free_entry()    get_free_entries(1)
> > > Is this necessary? Maybe you defined this to keep consistence
> with
> > > put_free_entry(ref)?
> > > But other functions such as gnttab_grant_foreign_transfer and
> > > gnttab_grant_foreign_access all call get_free_entries(1). Maybe
> it
> > > is better to keep initial get_free_entries(1) code?
> > Another approach is doing those work in a separate patch --
> changing
> > get_free_entries to get_free_entry in following 4 functions:
> 
> I think you shouldn't get too bogged down in get_free_entry() vs
> get_free_entries(1) for the purposes of this patch series.
> 

Annie,

  Yes, don't worry about get_free_entry(). I only defined it for the sake of symmetry in the code I posted.

  Paul
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
