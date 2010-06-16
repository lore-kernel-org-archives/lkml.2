Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478Ab0FPT3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 15:29:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54063 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669Ab0FPT3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 15:29:36 -0400
Date: Wed, 16 Jun 2010 15:29:34 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: sparclinux@vger.kernel.org, Simone Ricci <simone.ricci@gmail.com>,
       scst-devel@lists.sourceforge.net, Joe Eykholt <jeykholt@cisco.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How to printk/sprintf uint64_t on Sparc without format and
	argument types mismatch
Message-ID: <20100616192934.GX20317@bombadil.infradead.org>
References: <AANLkTimuv7nOlcGFxqPZlwcAjLmFMiLAvbA5O7F32Wbg@mail.gmail.com> <4C192113.7030101@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C192113.7030101@vlnb.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 11:08:03PM +0400, Vladislav Bolkhovitin wrote:
> scst/src/scst_targ.c:2136: warning: format ?%llx? expects type ?long  
> long unsigned int?, but argument 4 has type ?uint64_t?.
>
> It is because on Sparc uint64_t defined as unsigned long, but on x86 -  
> as unsigned long long.
>

>From your other mail, it looks like you're using 2.6.26... this is
ancient! Sparc has since been fixed to use unsigned long long for u64.

commit 9018113649348c689da107166c05d436cd52e7bf
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Tue Jan 6 13:19:28 2009 -0800

    sparc64: Use unsigned long long for u64.

regards, Kyle
