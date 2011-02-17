Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab1BQTeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:34:17 -0500
Received: from smtp.outflux.net ([198.145.64.163]:36640 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374Ab1BQTeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:34:14 -0500
Date: Thu, 17 Feb 2011 11:33:03 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.38-rc4 (test_nx: BUG)
Message-ID: <20110217193303.GS4000@outflux.net>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
 <20110209090804.5c1ecf8e.randy.dunlap@oracle.com>
 <4D52CA98.2050100@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D52CA98.2050100@linux.intel.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

On Wed, Feb 09, 2011 at 09:10:48AM -0800, Arjan van de Ven wrote:
> On 2/9/2011 9:08 AM, Randy Dunlap wrote:
> >test_nx BUGs.
> >CONFIG_DEBUG_RODATA=y
> >(nearly allmodconfig, with a few changes)
> >
> >Is that expected?
> >
> this test should pass...
> so something broke it (I'll call that a success for the test ;-)

I would suspect that the code in fudze_exception_table() isn't legal any
more due to the RO patches. (i.e. I think test_nx.c needs to be updated.)

-Kees

-- 
Kees Cook
Ubuntu Security Team
