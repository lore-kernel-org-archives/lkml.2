Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab2G0JsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 05:48:18 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:4164 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2G0JsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 05:48:17 -0400
X-IronPort-AV: E=Sophos;i="4.77,666,1336348800"; 
   d="scan'208";a="13731015"
Message-ID: <1343382495.6812.127.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH 18/24] xen/arm: compile blkfront and blkback
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Date: Fri, 27 Jul 2012 10:48:15 +0100
In-Reply-To: <1343316846-25860-18-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
	 <1343316846-25860-18-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 16:34 +0100, Stefano Stabellini wrote:
> 
> +#define XEN_IO_PROTO_ABI_ARM        "arm-abi" 

I wonder if we ought to call this arm-aarch32-abi or something?

I wonder if we can also take the opportunity to fix the ABI cockup for
disks on ARM and make the structs the same for both 32 and 64 bit?

Ian.

