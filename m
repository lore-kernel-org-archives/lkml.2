Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab1IVIX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 04:23:58 -0400
Received: from [124.207.24.138] ([124.207.24.138]:57384 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab1IVIXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 04:23:55 -0400
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Sep 2011 04:23:55 EDT
MIME-Version: 1.0
In-Reply-To: <CABJhkKRAO9w85O8f11+V5LoEk08q+S09xDjSXu_bMeb1dSa0Uw@mail.gmail.com>
References: <CABJhkKRAO9w85O8f11+V5LoEk08q+S09xDjSXu_bMeb1dSa0Uw@mail.gmail.com>
Date: Thu, 22 Sep 2011 16:16:47 +0800
Message-ID: <CAF1ivSYKUq_=mp_kx+39E6EJUGqKyb8hrxOyFonE3_SCpQ3kmw@mail.gmail.com>
Subject: Re: Any kernel fails to load after failed pm-hibernate with 3.0.0
From: Lin Ming <mlin@ss.pku.edu.cn>
To: Magnus Leuthner <magnus.leuthner@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 4:01 PM, Magnus Leuthner
<magnus.leuthner@googlemail.com> wrote:
> Hi,
>
> I've used pm-hibernate with a custom built 3.0.0 kernel to hibernate
> the system. The machine just hung there so I had to power it off
> (Thinkpad X61). Now none of my kernels will boot (neither 2.6.x nor
> the suspended 3.0.0), after selecing the kernel in the grub menu I get
> a black screen with the cursor blinking in the left top and no further
> activity (no disk access etc.). I tried the obvious things like adding
> in grub the kernel parameters "noresume" or "init=/bin/bash" to no
> use, same result. The kernel never shows any signs of life after
> selection in grub :(
>
> Any help highly appreciated.

Does "hibernate=noresume" help?

Lin Ming

>
> Kind regards
> Magnus
