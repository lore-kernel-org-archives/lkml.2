Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab1LGJ5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:57:31 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:59599 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1LGJ5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:57:30 -0500
X-IronPort-AV: E=Sophos;i="4.71,313,1320624000"; 
   d="scan'208";a="9336778"
Subject: RE: [PATCH 1/2] xen/granttable: Support sub-page grants
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Paul Durrant <Paul.Durrant@citrix.com>
CC: ANNIE LI <annie.li@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Date: Wed, 7 Dec 2011 09:57:29 +0000
In-Reply-To: <291EDFCB1E9E224A99088639C4762022B5988E542E@LONPMAILBOX01.citrite.net>
References: <4EDDF41E.8070200@oracle.com>
	 <1323168999-4434-1-git-send-email-annie.li@oracle.com>
	 <1323171726.23681.65.camel@zakaz.uk.xensource.com>
	 <4EDEDF2E.3040204@oracle.com>
	 <291EDFCB1E9E224A99088639C4762022B5988E542E@LONPMAILBOX01.citrite.net>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1323251849.23681.128.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 08:59 +0000, Paul Durrant wrote:
> > gnttab_v2_ops = {
> >   ...
> > .access_subpage = access_subpage_v2;
> > .access_ref_subpage = access_ref_subpage_v2; .access_trans =
> > access_trans_v2; .access_ref_trans = access_ref_trans_v2; }
> > 
> 
> 
> Do you need ops for the ref and non-ref functions? I would have
> thought you could just have the ref ones since the all the non-ref
> variants do is allocate and then call the ref variant.

Good point. It appears that all the existing ops are only present in the
ref form.

Ian.


