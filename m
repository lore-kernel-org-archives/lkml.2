Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab2KWPxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:53:33 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55705 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab2KWPxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:53:31 -0500
MIME-Version: 1.0
In-Reply-To: <1353683310-23654-4-git-send-email-ciminaghi@gnudd.com>
References: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com>
	<1353683310-23654-4-git-send-email-ciminaghi@gnudd.com>
Date: Fri, 23 Nov 2012 21:23:31 +0530
X-Google-Sender-Auth: X2uQsWev7k2x0CBhMfpoSwYv87k
Message-ID: <CAOh2x=keCbnPQzxB+AT5hEt_ukQ6GhPLuxkaQJCML27H9LbWwg@mail.gmail.com>
Subject: Re: [PATCH 3/8] pl080.h: moved from arm/include/asm/hardware to include/linux/amba/
From: viresh kumar <viresh.kumar@linaro.org>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org, rubini@gnudd.com,
        wim@iguana.be, cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, rajeev-dlh.kumar@st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 8:38 PM, Davide Ciminaghi <ciminaghi@gnudd.com> wrote:
> From: Alessandro Rubini <rubini@gnudd.com>
>
> The header is used by drivers/dma/amba-pl08x.c, which can be compiled
> under x86, where PL080 exists under a PCI-to-AMBA bridge. This patche
> moves it where it can be accessed by other architectures, and fixes
> all users.
>
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> ---
>  arch/arm/include/asm/hardware/pl080.h |  146 ---------------------------------
>  arch/arm/mach-s3c64xx/dma.c           |    2 +-
>  arch/arm/mach-spear3xx/spear3xx.c     |    2 +-
>  arch/arm/mach-spear6xx/spear6xx.c     |    2 +-
>  drivers/dma/amba-pl08x.c              |    2 +-
>  include/linux/amba/pl080.h            |  146 +++++++++++++++++++++++++++++++++
>  6 files changed, 150 insertions(+), 150 deletions(-)
>  delete mode 100644 arch/arm/include/asm/hardware/pl080.h
>  create mode 100644 include/linux/amba/pl080.h

Again, generating this patch with

git format-patch -C -M would have given us an easier patch to review.

--
viresh
