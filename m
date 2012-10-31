Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794Ab2JaVFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:05:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50504 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760679Ab2JaVFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:05:30 -0400
Date: Wed, 31 Oct 2012 22:05:22 +0100
From: Robert Richter <rric@kernel.org>
To: "Zhang, Jun" <jun.zhang@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Sometimes, there is OOPS happened when we use oprofile.
Message-ID: <20121031210522.GB4386@ivy.homofaber>
References: <88DC34334CA3444C85D647DBFA962C270FD7E416@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88DC34334CA3444C85D647DBFA962C270FD7E416@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jun,

On 29.10.12 02:33:54, Zhang, Jun wrote:
> Sometimes, there is OOPS happened when we use oprofile. next
> is the call stack. From call stack, we find in
> call_on_stack if there is a nmi interrupt between "xchgl
> %%ebx,%%esp" and "call *%%edi", system will OOPS.

this should be related and fixed with:

 https://lkml.org/lkml/2012/9/12/269

Ingo, HPA,

please apply the fix of kernel_stack_pointer().

Thanks,

-Robert
