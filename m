Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab1KGU56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:57:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45359 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab1KGU55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:57:57 -0500
Message-ID: <4EB84644.8060102@zytor.com>
Date: Mon, 07 Nov 2011 12:57:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] x86, efi: Calling __pa() with an ioremap'd address
 is invalid
References: <1320680088-2584-1-git-send-email-matt@console-pimps.org> <20111107202324.GA27515@srcf.ucam.org> <4EB8413D.6030500@zytor.com> <20111107203752.GA27875@srcf.ucam.org> <4EB8436B.20603@zytor.com> <20111107204839.GA28261@srcf.ucam.org>
In-Reply-To: <20111107204839.GA28261@srcf.ucam.org>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 12:48 PM, Matthew Garrett wrote:
> 
> If the kernel is able to call boot services then the kernel needs to be 
> signed. If it's all handled by the bootloader then the bootloader can be 
> signed and the kernel doesn't have to be. Depends which one people 
> update more, I guess.
> 

... and what security attributes they are looking for.

However, "EFI stub in the kernel" doesn't mean "can't use an external
bootloader."

	-hpa
