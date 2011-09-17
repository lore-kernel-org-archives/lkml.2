Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab1IQI63 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 04:58:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57363 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab1IQI62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 04:58:28 -0400
Date: Sat, 17 Sep 2011 09:58:18 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Tzu-Jung Lee <roylee17@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tzu-Jung Lee <tjlee@ambarella.com>
Subject: Re: [PATCH] ARM: tlb: Compile out MULTI_TLB specific code when
	MULTI_TLB is undefined
Message-ID: <20110917085818.GA9262@flint.arm.linux.org.uk>
References: <1316190666-18905-1-git-send-email-tjlee@ambarella.com> <20110916200040.GA18566@flint.arm.linux.org.uk> <CAEvN+1ihRxe4g2wVErEWtg-VSw9dEL5R7YkufdGst5dEyzN8eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEvN+1ihRxe4g2wVErEWtg-VSw9dEL5R7YkufdGst5dEyzN8eQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 11:19:02AM +0800, Tzu-Jung Lee wrote:
> Indeed, this is only one of the places where we used to particularly
> build with higher optimization level. More than often, we only disable
> the optimization for interested object files with CFLAGS_foo.o += -g
> -O0. While porting kernel to different platforms, however, failures at
> the early booting stage usually makes low level
> initialization(mm/tlb/cache/cpu...) become the objects that we want to
> disable the optimization for the ease of diagnostic with source level
> debugger. In this cases, patches to the source code become required to
> get the -O0 work for them. Would you consider to have these patches
> merged if they doesn't have side effect.

We've gone some 17 or so years without needing -O0 to debug the kernel.
Why has it now become necessary?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
