Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab2JIQGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:06:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49157 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab2JIQGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:06:14 -0400
Date: Tue, 9 Oct 2012 17:04:41 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com
Subject: Re: [PATCH 5/9] ARM: Xen: fix initial build problems:
Message-ID: <20121009160441.GF4625@n2100.arm.linux.org.uk>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de> <1349796183-30648-6-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349796183-30648-6-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 05:22:59PM +0200, Arnd Bergmann wrote:
> * The XEN_BALLOON code requires the balloon infrastructure that is not
>   getting built on ARM.
> 
> * The tmem hypercall is not available on ARM
> 
> * ARMv6 does not support cmpxchg on 16-bit words that are used in the

"in the" what?

