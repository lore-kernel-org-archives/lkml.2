Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab2JRKuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:50:13 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:8055 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab2JRKuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:50:11 -0400
X-IronPort-AV: E=Sophos;i="4.80,606,1344211200"; 
   d="scan'208";a="15251311"
Message-ID: <1350557371.2460.117.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH V3 4/6]: PVH:bootup and setup related
 changes.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 18 Oct 2012 11:49:31 +0100
In-Reply-To: <20121017173223.7ea1901d@mantra.us.oracle.com>
References: <20121017173223.7ea1901d@mantra.us.oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 01:32 +0100, Mukesh Rathor wrote:
> 
> +       /* PVH TBD/FIXME: vcpu info placement in phase 2 */
> +       if (xen_pvh_domain())
> +               return; 

Do you have a list of future work before PVH is "feature complete"
somewhere?

I wouldn't count vcpu placement specifically against completeness but
the TBD triggered the thought.

For example I was reviewing a migration patch this morning and was
wondering if that sort of thing had been investigated yet.

Ian.

