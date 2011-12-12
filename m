Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab1LLHKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:10:37 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:63655 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab1LLHKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:10:35 -0500
X-IronPort-AV: E=Sophos;i="4.71,337,1320624000"; 
   d="scan'208";a="9407400"
Subject: Re: [PATCH V3 1/2] xen/granttable: Support sub-page grants
From: Ian Campbell <Ian.Campbell@citrix.com>
To: ANNIE LI <annie.li@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Paul Durrant <Paul.Durrant@citrix.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
In-Reply-To: <4EE57204.4030509@oracle.com>
References: <1323430321-5465-1-git-send-email-annie.li@oracle.com>
	 <1323430372-5503-1-git-send-email-annie.li@oracle.com>
	 <1323452339.20077.92.camel@zakaz.uk.xensource.com>
	 <4EE57204.4030509@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Mon, 12 Dec 2011 07:10:33 +0000
Message-ID: <1323673833.20936.65.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 03:16 +0000, ANNIE LI wrote:
> > Please can you name the arguments here and then refer to them by name in
> > the comments instead of all this "First parameter", "second one" stuff.
> >
> > Similarly for the existing comments sorry I didn't notice this in
> > previous review.
> Please check following comments in gnttab_ops, I changed the "First 
> parameter", "second one" into parameter name. However, it looks not very 
> consistent with parameters format of function fn since only parameter 
> type exists, not name.

You can give the parameters names in the function pointers too, that's
what I was suggesting.

e.g.:
         int (*map_frames)(unsigned long *frames, unsigned int nr);

Ian.

