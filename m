Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab1K2JQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 04:16:46 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55125 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab1K2JQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 04:16:42 -0500
Date: Tue, 29 Nov 2011 09:15:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        David Brown <davidb@codeaurora.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: Re: [PATCH 0/3] Change ARCH_NR_GPIO into a Kconfig variable
Message-ID: <20111129091552.GI9581@n2100.arm.linux.org.uk>
References: <1320339647-30255-1-git-send-email-pdeschrijver@nvidia.com> <20111129064630.GW19069@tbergstrom-lnx.Nvidia.com> <CACRpkdY-YL0RSY4+nL36sM9WwX+VbMkJP54djrCwYCQmw9AFEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdY-YL0RSY4+nL36sM9WwX+VbMkJP54djrCwYCQmw9AFEw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 09:40:27AM +0100, Linus Walleij wrote:
> On Tue, Nov 29, 2011 at 7:46 AM, Peter De Schrijver
> <pdeschrijver@nvidia.com> wrote:
> > On Thu, Nov 03, 2011 at 06:00:44PM +0100, Peter De Schrijver wrote:
> >> This patchset converts ARCH_NR_GPIO to a Kconfig variable as suggested by
> >> Russel King. It also converts some platforms to the new model.
> >>
> >> Peter De Schrijver (3):
> >>   ARM: ARCH_NR_GPIO: Make ARCH_NR_GPIO a Kconfig variable
> >>   ARM: mach-shmobile: Use CONFIG_ARCH_NR_GPIO
> >>   ARM: mach-ux500 Use CONFIG_ARCH_NR_GPIO
> >
> > Ping? What should we do with this?
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Put it into Russell's patch tracker.

Or we could wait for Grant to reappear and take it.
