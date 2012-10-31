Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934903Ab2JaCrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 22:47:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50749 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759802Ab2JaCrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 22:47:10 -0400
Message-ID: <50909120.3040101@zytor.com>
Date: Tue, 30 Oct 2012 19:46:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Zhang, Jun" <jun.zhang@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] To crash dump, we need keep other memory type except
 E820_RAM, because other type come from BIOS or firmware is used by other
 code(for example: PCI_MMCONFIG).
References: <88DC34334CA3444C85D647DBFA962C270FD7EAD3@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <88DC34334CA3444C85D647DBFA962C270FD7EAD3@SHSMSX102.ccr.corp.intel.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2012 06:26 PM, Zhang, Jun wrote:
> From aebc336baa7ec2d4ccb6f21166770c7d2ee26cba Mon Sep 17 00:00:00 2001
> From: jzha144 <jun.zhang@intel.com>
> Date: Wed, 31 Oct 2012 08:51:18 +0800
> Subject: [PATCH] To crash dump, we need keep other memory type except
>  E820_RAM, because other type come from BIOS or firmware is
>  used by other code(for example: PCI_MMCONFIG).

I'm sorry, I can't quite parse the description or the comment... could
you clarify it a bit?  I think I know what you mean, but there is
clearly risk for misunderstandings.

	-hpa

