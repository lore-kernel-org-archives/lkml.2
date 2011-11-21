Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab1KUKgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:36:46 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:45980 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab1KUKgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:36:45 -0500
X-IronPort-AV: E=Sophos;i="4.69,546,1315180800"; 
   d="scan'208";a="9035893"
Subject: Re: [Xen-devel] [PATCH 1/3] xen/granttable: Introducing grant table
 V2 stucture
From: Ian Campbell <Ian.Campbell@citrix.com>
To: ANNIE LI <annie.li@oracle.com>
CC: "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Durrant <Paul.Durrant@citrix.com>
Date: Mon, 21 Nov 2011 10:36:36 +0000
In-Reply-To: <4ECA1F0D.5070303@oracle.com>
References: <4EC3B62F.6080702@oracle.com>
	 <1321451304-13559-1-git-send-email-annie.li@oracle.com>
	 <4EC62E77.7090007@oracle.com>
	 <1321613689.3664.305.camel@zakaz.uk.xensource.com>
	 <4EC6818B.3010904@oracle.com>
	 <1321632271.3664.367.camel@zakaz.uk.xensource.com>
	 <4ECA1F0D.5070303@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1321871797.3664.376.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 09:51 +0000, ANNIE LI wrote:
> This patch changes two places from the last one,
> * removing gnttab_v1_ops
> * change update_grant_entry_v1 into gnttab_update_entry_v1

The attached patch didn't have those changes.

Ian.

> 
> Thanks
> Annie
> 
> On 2011-11-19 0:04, Ian Campbell wrote:
> >>>> +static struct gnttab_ops gnttab_v1_ops = {
> >>>> +       .map_frames                     = gnttab_map_frames_v1,
> >>>> +       .unmap_frames                   = gnttab_unmap_frames_v1,
> >>>> +       .update_entry                   = update_grant_entry_v1,
> >>>>
> >>> Any reason this one is not gnttab_foo?
> >>>
> >> Actually no, just keep the original name of this function. I'd like to
> >> change it, maybe gnttab_update_entry_v1 is better?
> > I think so. Similarly for the v2 variant.
> >
> > Ian.
> >
> >


