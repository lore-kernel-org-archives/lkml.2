Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab2E1Xi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 19:38:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46898 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab2E1Xi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 19:38:57 -0400
Message-ID: <4FC40C74.8050003@zytor.com>
Date: Mon, 28 May 2012 16:38:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Samuel Ortiz <sameo@linux.intel.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86/platform: sta2x11: add platform code
References: <20120527205020.GA3050@mail.gnudd.com>
In-Reply-To: <20120527205020.GA3050@mail.gnudd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2012 01:50 PM, Alessandro Rubini wrote:
> This adds platform code for the STA2X11 (aka ConneXt) I/O Hub,
> including support for the Intel NorthVille evaluation board and the
> ST-Eval PCIe carrier.
> 
> The boards differ for the amount of peripherals actually wired out,
> GPIO configuration and some accessory pins. At this point, platform
> data for peripherals other tha GPIO is not instantiated because the
> drivers are not yet upstream.
> 
> The array of supported boards is built using a local ELF section to
> avoid ifdef; the section is folded in the .data section by a local
> linker script.
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> Cc: Alan Cox <alan@linux.intel.com>

Nacked-in-the-extreme-by: H. Peter Anvin <hpa@zytor.com>

There is absolutely NO WAY this kind of ARM-like sh*t is going into the
x86 kernel.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

