Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab0IVRzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 13:55:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42375 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565Ab0IVRzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 13:55:20 -0400
Message-ID: <4C9A42E9.7040109@zytor.com>
Date: Wed, 22 Sep 2010 10:54:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: tidy e820 output
References: <20100922172744.19085.41844.stgit@bob.kio>
In-Reply-To: <20100922172744.19085.41844.stgit@bob.kio>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 10:27 AM, Bjorn Helgaas wrote:
> 
> This tidies e820 output by adding an "e820" prefix and printing ranges in
> the same style we use for struct resource with %pR, e.g.:
> 
>     - BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
>     + BIOS-e820: [mem 0x00000000-0x0009f3ff] (usable)
> 

I'm sorry, I have to admit to not understanding the difference.  I do
not want to change the number of hex digits from fixed 16 digits, as
that will make the output harder to read when printed in a block (as is
normal for the early e820 dump).  The [mem] prefix seems redundant with
(usable), or am I misreading this?

	-hpa
