Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab1JJTUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 15:20:06 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:49435 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab1JJTUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 15:20:04 -0400
X-IronPort-AV: E=Sophos;i="4.68,518,1312156800"; 
   d="scan'208";a="8311799"
Subject: Re: [Xen-devel] [PATCH 3/3] xen/blk[front|back]: Enhance discard
 support with secure erasing support.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Jan Beulich <JBeulich@novell.com>, Li Dongyang <lidongyang@novell.com>
In-Reply-To: <20111010164250.GG28646@phenom.oracle.com>
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
	 <1318260494-27985-4-git-send-email-konrad.wilk@oracle.com>
	 <1318263187.21903.464.camel@zakaz.uk.xensource.com>
	 <20111010164250.GG28646@phenom.oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Mon, 10 Oct 2011 20:20:02 +0100
Message-ID: <1318274402.27397.13.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 17:42 +0100, Konrad Rzeszutek Wilk wrote:
> On Mon, Oct 10, 2011 at 05:13:07PM +0100, Ian Campbell wrote:

> > In any case it should also be posted against the canonical inter-guest
> > interface definition in the xen tree for review with that in mind.
> 
> Yes! But I was thinking to first let this one rattle a bit and see what
> folks thought about it before submitting the xen-devel.

It's a good idea to get ABI changes out for review before the
implementation rattles around so much that changing it becomes hard.

Ian.

