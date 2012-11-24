Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750966Ab2KXFOi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 00:14:38 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37085 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab2KXFOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 00:14:37 -0500
MIME-Version: 1.0
In-Reply-To: <1353718436-20194-1-git-send-email-ciminaghi@gnudd.com>
References: <CAKohpokUHv96wutU1ZLxxnndR3wfTr3kjh3UKREtuiVV-V8+EA@mail.gmail.com>
	<1353718436-20194-1-git-send-email-ciminaghi@gnudd.com>
Date: Sat, 24 Nov 2012 10:44:36 +0530
Message-ID: <CAJe_ZhcGmeTviV8v8eCMFZTWLnOb24_kVa1TkZF=9oyc6=vA4A@mail.gmail.com>
Subject: Re: [PATCH 1/8 v3] DMA: PL330: use prefix in reg names to build under x86
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: viresh.linux@gmail.com, giancarlo.asnaghi@st.com, rajeev-dlh.kumar@st.com,
        linux@arm.linux.org.uk, nico@fluxnic.net, vinod.koul@intel.com,
        linus.walleij@linaro.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, wim@iguana.be, mingo@redhat.com,
        ben-linux@fluff.org, djbw@fb.com, tglx@linutronix.de, cjb@laptop.org,
        rubini@gnudd.com, linux-arm-kernel@lists.infradead.org,
        davidb@codeaurora.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 November 2012 06:23, Davide Ciminaghi <ciminaghi@gnudd.com> wrote:
> From: Alessandro Rubini <rubini@gnudd.com>
>
> This driver would not compile if ARM_AMBA is selected under x86,
> because "CS" and "DS" are already defined there.  But AMBA
> is used in the x86 world by a PCI-to-AMBA bridge, to be submitted.
>
> The patch just adds the "PL330_" prefix to all register and bit fields,
> so it can be built by randomconfig after ARM_AMBA appears within x86.

Prefixing only CS and DS should be do the job.
Why do we have to make every symbol noisy with PL330_ ?
