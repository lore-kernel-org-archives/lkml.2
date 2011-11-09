Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab1KIQWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:22:08 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:24835 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab1KIQWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:22:05 -0500
X-IronPort-AV: E=Sophos;i="4.69,484,1315180800"; 
   d="scan'208";a="8845056"
Subject: Re: [Xen-devel] RE: [PATCH 1/3] Introducing grant table V2 stucture
From: Ian Campbell <Ian.Campbell@citrix.com>
To: annie li <annie.li@oracle.com>
CC: Paul Durrant <Paul.Durrant@citrix.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Date: Wed, 9 Nov 2011 16:22:04 +0000
In-Reply-To: <4EBAA3B1.8010401@oracle.com>
References: <4EBA35D3.3020506@oracle.com>
	 <1320826490-29362-1-git-send-email-annie.li@oracle.com>
	 <291EDFCB1E9E224A99088639C4762022B4543AB1BD@LONPMAILBOX01.citrite.net>
	 <20111109144922.GC8410@phenom.dumpdata.com>
	 <291EDFCB1E9E224A99088639C4762022B4543AB204@LONPMAILBOX01.citrite.net>
	 <4EBAA3B1.8010401@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1320855724.955.183.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 16:00 +0000, annie li wrote:
> Maybe addr or gnttab_addr?

IMHO the gnttab_ bit belongs in either (or both) the struct name or the
variable names referencing the struct, rather than the fields
themselves. It should be obvious from the context that this member is
something to do with gnttab. e.g. I think gnttab_shared->addr would be
fine, as would shared->addr in the context of gnttab.c etc.

Ian.


