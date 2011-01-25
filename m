Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1AYQyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 11:54:35 -0500
Received: from smtp.citrix.com ([66.165.176.89]:6497 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab1AYQye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 11:54:34 -0500
X-IronPort-AV: E=Sophos;i="4.60,374,1291611600"; 
   d="scan'208";a="12122882"
Subject: Re: [Xen-devel] [PATCH] xen: p2m: correctly initialize partial p2m
 leave
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefan Bader <stefan.bader@canonical.com>
CC: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4D3848DF.9000906@canonical.com>
References: <4D3848DF.9000906@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 25 Jan 2011 16:54:32 +0000
Message-ID: <1295974472.14780.6579.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please always include an inline copy of a patch for easier
review-by-reply, even if you also include an attachment because your
mailer mangles patches.

Anyway, I suspect the following comment is obsoleted by Jeremy's "just
do it in place" suggestion but:

On Thu, 2011-01-20 at 14:38 +0000, Stefan Bader wrote:
> [...]
> +                       unsigned long **p2m = extend_brk(PAGE_SIZE, PAGE_SIZE);

I think this would need to be matched by a corresponding RESERVE_BRK of some sort.

Ian.


