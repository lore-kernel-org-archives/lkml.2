Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab1LGTlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 14:41:49 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:56054 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581Ab1LGTls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 14:41:48 -0500
Date: Wed, 7 Dec 2011 15:41:34 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Paul Durrant <Paul.Durrant@citrix.com>
Cc: ANNIE LI <annie.li@oracle.com>, Ian Campbell <Ian.Campbell@citrix.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH 1/2] xen/granttable: Support sub-page grants
Message-ID: <20111207194134.GA8812@andromeda.dapyr.net>
References: <4EDDF41E.8070200@oracle.com> <1323168999-4434-1-git-send-email-annie.li@oracle.com> <1323171726.23681.65.camel@zakaz.uk.xensource.com> <4EDEDF2E.3040204@oracle.com> <291EDFCB1E9E224A99088639C4762022B5988E542E@LONPMAILBOX01.citrite.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <291EDFCB1E9E224A99088639C4762022B5988E542E@LONPMAILBOX01.citrite.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > gnttab_v1_ops = {
> >   ...
> > .access_subpage = NULL;
> > .access_ref_subpage = NULL;
> > .access_trans = NULL;
> > .access_ref_trans = NULL;
> > }

You don't really need that. If you just leave it empty, they are all set
to NULL.
