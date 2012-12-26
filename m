Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab2LZXNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 18:13:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50572 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab2LZXNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 18:13:40 -0500
Message-ID: <50DB8485.8010709@zytor.com>
Date: Wed, 26 Dec 2012 15:13:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/build] x86: Default to ARCH= x86 to avoid overriding
 CONFIG_64BIT
References: <1356040315.3198.51.camel@shinybook.infradead.org> <tip-ffee0de411fd4f74f3b788892eeb075abbf26c52@git.kernel.org> <alpine.DEB.2.00.1212252222450.24528@chino.kir.corp.google.com> <1356511396.7010.13.camel@shinybook.infradead.org> <alpine.DEB.2.00.1212260228200.10166@chino.kir.corp.google.com> <1356525527.7010.34.camel@shinybook.infradead.org> <alpine.DEB.2.00.1212261343210.20193@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1212261343210.20193@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2012 02:00 PM, David Rientjes wrote:
 >
> In the past, "make randconfig" would always generate a
> kernel that _should_ boot on that machine unless there was an underlying
> bug that should be fixed.
 >

Not even remotely true.  There are tons of options which may not be set 
that your machine needs, or you might set options that exclude support 
for your CPU, for example.

Seriously, this is a bad joke.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

