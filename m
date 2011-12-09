Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab1LIIhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 03:37:10 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:60652 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1LIIhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 03:37:09 -0500
X-IronPort-AV: E=Sophos;i="4.71,325,1320624000"; 
   d="scan'208";a="9377047"
Subject: Re: [PATCH V2 1/2] xen/granttable: Support sub-page grants
From: Ian Campbell <Ian.Campbell@citrix.com>
To: annie li <annie.li@oracle.com>
CC: Paul Durrant <Paul.Durrant@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Date: Fri, 9 Dec 2011 08:37:04 +0000
In-Reply-To: <4EE1BC7E.3060904@oracle.com>
References: <1323336940-5382-1-git-send-email-annie.li@oracle.com>
	 <1323337048-5426-1-git-send-email-annie.li@oracle.com>
	 <291EDFCB1E9E224A99088639C4762022B5988E5528@LONPMAILBOX01.citrite.net>
	 <4EE08B0D.80504@oracle.com>
	 <291EDFCB1E9E224A99088639C4762022B5988E552D@LONPMAILBOX01.citrite.net>
	 <4EE19A4D.9030500@oracle.com> <4EE1BC7E.3060904@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1323419827.20077.3.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-09 at 07:45 +0000, annie li wrote:
> 
> On 2011-12-9 13:19, annie li wrote:
> > Hi Paul,
> >
> >>>> #define get_free_entry()    get_free_entries(1)
> > Is this necessary? Maybe you defined this to keep consistence with 
> > put_free_entry(ref)?
> > But other functions such as gnttab_grant_foreign_transfer and 
> > gnttab_grant_foreign_access all call get_free_entries(1). Maybe it is 
> > better to keep initial get_free_entries(1) code?
> Another approach is doing those work in a separate patch -- changing 
> get_free_entries to get_free_entry in following 4 functions:

I think you shouldn't get too bogged down in get_free_entry() vs
get_free_entries(1) for the purposes of this patch series.

Ian.

> gnttab_grant_foreign_access
> gnttab_grant_foreign_access_subpage
> gnttab_grant_foreign_access_trans
> gnttab_grant_foreign_transfer
> 
> Thanks
> Annie


