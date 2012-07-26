Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab2GZRUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 13:20:41 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:32391 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab2GZRUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 13:20:40 -0400
X-IronPort-AV: E=Sophos;i="4.77,660,1336348800"; 
   d="scan'208";a="13721023"
Date: Thu, 26 Jul 2012 18:19:46 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: David Vrabel <dvrabel@cantab.net>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH 02/24] xen/arm: hypercalls
In-Reply-To: <501176AF.3000607@cantab.net>
Message-ID: <alpine.DEB.2.02.1207261813080.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com> <1343316846-25860-2-git-send-email-stefano.stabellini@eu.citrix.com> <501176AF.3000607@cantab.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2012, David Vrabel wrote:
> On 26/07/12 16:33, Stefano Stabellini wrote:
> > 
> > + * The hvc ISS is required to be 0xEA1, that is the Xen specific ARM
> > + * hypercall tag.
> 
> Is this number, 0xea1, assigned to Xen by some external body?

I am not aware of any "external body" that could assign us such a number
but it is specified in the Xen hypercall calling convention, documented
here:

http://xenbits.xensource.com/hg/xen-unstable.hg/file/663eb766cdde/xen/include/public/arch-arm.h
