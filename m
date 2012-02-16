Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab2BPWPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 17:15:20 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34561 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab2BPWPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 17:15:19 -0500
Date: Thu, 16 Feb 2012 22:14:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        giancarlo.asnaghi@st.com, alan@linux.intel.com
Subject: Re: [PATCH] ARM: amba: don't include <asm/sizes.h>
Message-ID: <20120216221455.GK27825@n2100.arm.linux.org.uk>
References: <20120216160525.GA30558@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216160525.GA30558@mail.gnudd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 05:05:25PM +0100, Alessandro Rubini wrote:
> The file uses no SZ_* symbol and some architectures miss sizes.h
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> ---
> 
> There a number of files including but not using it. This one
> in particular I need under x86 so the fix is trivial.
> 
> However, I remember different feelings about sizes.h . Should it die
> or should it proliferate to other archs using asm-generic/sizes.h ?

If you're going to continue with this change, please make sure you
test build Versatile Express, Versatile and Realview to ensure that
this doesn't cause breakage.
