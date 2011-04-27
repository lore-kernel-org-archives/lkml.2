Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122Ab1D0Udh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:33:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40963 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab1D0Udg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:33:36 -0400
Message-ID: <4DB87D93.4060108@zytor.com>
Date: Wed, 27 Apr 2011 13:33:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCH][RESEND] Fix EDD3.0 data verification.
References: <20110426082132.GG2265@redhat.com> <4DB74A6C.2080702@zytor.com> <20110427123213.GL2265@redhat.com>
In-Reply-To: <20110427123213.GL2265@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2011 05:32 AM, Gleb Natapov wrote:
> 
> This patch is only fixes obviously incorrect code in edd_has_edd30()
> to do proper check instead of summing random memory and it should be
> applied even if we decide that we want to support Phoenix spec too.
> 
> I looked into implementing support for Phoenix spec back then when I
> wrote the patch and I decided against it. The main (and may be only)
> use case for edd module is to provide OS installer with enough info
> for it to decide where to install boot loader. Unfortunately Phoenix
> EDD spec does not support most modern storage technologies and even for
> legacy one such as ATA it does not provide enough info to determine boot
> disk correctly (you can't tell the difference between two ATA channels,
> T13 spec provides this info in interface path along with PCI address).
> So even if we would have support for it the OS installer will have to
> check if the information comes from T13 or Phoenix and ignore it if it's
> the later.
> 

I still think it would be a lot better to let userspace decide how it
wants to handle things, but oh well.

	-hpa

