Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab2GIOjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:39:42 -0400
Received: from smtp.citrix.com ([66.165.176.89]:16193 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab2GIOjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:39:40 -0400
X-IronPort-AV: E=Sophos;i="4.77,552,1336363200"; 
   d="scan'208";a="30845529"
Message-ID: <1341844722.12805.10.camel@hastur.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH 0/4] x86/xen: page fault and context switch
 performance (v2)
From: Ian Campbell <ian.campbell@citrix.com>
To: David Vrabel <david.vrabel@citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 9 Jul 2012 08:38:42 -0600
In-Reply-To: <1341830348-15529-1-git-send-email-david.vrabel@citrix.com>
References: <1341830348-15529-1-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 06:39 -0400, David Vrabel wrote:
> This series improves the performance of Xen PV guests when doing page
> faults (32-bit guests only) and context switches.

These all look good to me, thanks David.

Acked-by: Ian Campbell <ian.campbell@citrix.com>


