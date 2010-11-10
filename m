Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab0KJOj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:39:27 -0500
Received: from gate.crashing.org ([63.228.1.57]:54364 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109Ab0KJOjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:39:24 -0500
Subject: Re: [PATCH] ppc44x:PHY fixup for USB on canyonlands board
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Rupjyoti Sarmah <rsarmah@amcc.com>, linuxppc-dev@ozlabs.org,
        rsarmah@apm.com, linux-kernel@vger.kernel.org
In-Reply-To: <20101110141914.GC26193@zod.rchland.ibm.com>
References: <201011101137.oAABbFoc015547@amcc.com>
	 <20101110141914.GC26193@zod.rchland.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 01:38:51 +1100
Message-ID: <1289399931.2147.1392.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 09:19 -0500, Josh Boyer wrote:
> With this being an arch_initcall, it will get called for every kind of
> platform in a multi-board kernel.  Another reason to only call it from
> a
> board specific probe function if it really is canyonlands specific. 

Right. Time to take canyonlands out of ppc4xx_simple and have its own
board file again. Do the fixups there.

Cheers,
Ben.


