Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab0GMGlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 02:41:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55428 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab0GMGlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 02:41:15 -0400
Message-ID: <4C3C0A73.1090602@zytor.com>
Date: Mon, 12 Jul 2010 23:40:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: tip/master broken with x2apic and kexec
References: <4C3BD6AA.3070908@kernel.org> <4C3BDDA3.2060900@kernel.org>
In-Reply-To: <4C3BDDA3.2060900@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 08:29 PM, Yinghai Lu wrote:
>
> offending patch is
>
> commit 83a7a2ad2a9173dcabc05df0f01d1d85b7ba1c2c
> Author: H. Peter Anvin<hpa@linux.intel.com>
> Date:   Thu Jun 10 00:10:43 2010 +0000
>
>      x86, alternatives: Use 16-bit numbers for cpufeature index
>
>      We already have cpufeature indicies above 255, so use a 16-bit number
>      for the alternatives index.  This consumes a padding field and so
>      doesn't add any size, but it means that abusing the padding field to
>      create assembly errors on overflow no longer works.  We can retain the
>      test simply by redirecting it to the .discard section, however.
>
>      [ v3: updated to include open-coded locations ]
>
>      Signed-off-by: H. Peter Anvin<hpa@linux.intel.com>
>      LKML-Reference:<tip-f88731e3068f9d1392ba71cc9f50f035d26a0d4f@git.kernel.org>
>      Signed-off-by: H. Peter Anvin<hpa@zytor.com>
>

Oh, good grief, what the hell is wrong with it this time...

	-hpa
