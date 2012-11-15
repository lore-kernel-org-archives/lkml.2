Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768584Ab2KORuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 12:50:44 -0500
Received: from multi.imgtec.com ([194.200.65.239]:54469 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1768535Ab2KORun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 12:50:43 -0500
Message-ID: <50A52B45.6030907@imgtec.com>
Date: Thu, 15 Nov 2012 17:49:57 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <arnd@arndb.de>,
        Ralf Baechle <ralf@linux-mips.org>, <linux-mips@linux-mips.org>
Subject: Re: [RFC PATCH v1 26/31] ARC: Build system: Makefiles, Kconfig, Linker
 script
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-27-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1352281674-2186-27-git-send-email-vgupta@synopsys.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_11_15_17_50_10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vineet,

On 07/11/12 09:47, Vineet Gupta wrote:
> +config ARC

I just came across arch/mips/Kconfig which also defines ARC (and ARC32).
It's only used within arch/mips/, however it's probably more likely that
your ARC/CONFIG_ARC will find it's way into the generic bits of the
kernel which could get hit when the other ARC is defined.

Perhaps it's worth getting the other ARC renamed just in case?

Cheers
James

