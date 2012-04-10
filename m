Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab2DJSxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 14:53:23 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:60754 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab2DJSxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 14:53:21 -0400
Message-ID: <1334084007.16827.38.camel@key-ThinkPad-W510>
Subject: Re: [PATCH v2 14/17] powerpc: crypto: nx driver code supporting nx
 encryption
From: Kent Yoder <key@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        rcj@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org
Date: Tue, 10 Apr 2012 13:53:27 -0500
In-Reply-To: <20120410.144136.1777978593334560368.davem@davemloft.net>
References: <1334070249.16827.1.camel@key-ThinkPad-W510>
	 <1334070657.16827.29.camel@key-ThinkPad-W510>
	 <20120410.144136.1777978593334560368.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041018-3270-0000-0000-0000057425FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Tue, 2012-04-10 at 14:41 -0400, David Miller wrote:
> From: Kent Yoder <key@linux.vnet.ibm.com>
> Date: Tue, 10 Apr 2012 10:10:57 -0500
> 
> > These routines add the base device driver code supporting the Power7+
> > in-Nest encryption accelerator (nx) device.
> > 
> > Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
> 
> This patch should be earlier in the series, so it can
> appear before the drivers which use the helper routines
> in here.

  I wasn't sure which order to post these in since the structures I
register with the crypto api in this patch live in the earlier .c files,
so there's a circular dependency.  I can reorder if you want though.

Kent

> 


