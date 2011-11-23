Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1KWMGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:06:35 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57347 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab1KWMGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:06:34 -0500
MIME-Version: 1.0
In-Reply-To: <CPSMTPM-CMT101y332G000633f8@CPSMTPM-CMT101.kpnxchange.com>
References: <CPSMTPM-CMT101y332G000633f8@CPSMTPM-CMT101.kpnxchange.com>
Date: Wed, 23 Nov 2011 13:06:33 +0100
Message-ID: <CAFLxGvwD83br-kW5TSVefruQ3cxwG6boDdnhMQC1879zotJh1w@mail.gmail.com>
Subject: Re: Fast memcpy patch
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: "N. Coesel" <nico@nctdev.nl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 12:25 PM, N. Coesel <nico@nctdev.nl> wrote:
> Dear readers,
> I noticed the Linux kernel still uses a byte-by-byte copy method for memcpy.
> Since most memory allocations are aligned to the integer size of a cpu it is
> often faster to copy by using the CPU's native word size. The patch below
> does that. The code is already at work in many 16 and 32 bit embedded
> products. It should also work for 64 bit platforms. So far I only tested 16
> and 32 bit platforms.

Please note, this is only the fallback implementation.
Each arch has it's own optimized version.

-- 
Thanks,
//richard
