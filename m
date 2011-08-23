Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab1HWJUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:20:40 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46018 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754576Ab1HWJUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:20:38 -0400
Date: Tue, 23 Aug 2011 11:20:36 +0200
From: Sebastian Siewior <sebastian@breakpoint.cc>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        linux-kernel@vger.kernel.org
Subject: Re: boot fails if x2apic is enabled unless efishell is used
Message-ID: <20110823092036.GA6425@breakpoint.cc>
References: <20110816210811.GA3331@breakpoint.cc>
 <201108212106.12427.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108212106.12427.maciej.rutecki@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thus spake Maciej Rutecki (maciej.rutecki@gmail.com):
> On wtorek, 16 sierpnia 2011 o 23:08:11 Sebastian Andrzej Siewior wrote:
> > This is Intel i7 Sandy bridge on Asrock Z68 Pro3-M.
> > 
> > EFI -> GRUB -> Kernel -> crash
> > EFI -> efishell -> GRUB -> Kernel -> works
> > 
> 
> Old kernels (eg. 3.0.0, or 2.6.39) work OK?

I tried the Debian installer for stable and unstable and stable is
2.6.32 I think.

> Regards

Sebastian
