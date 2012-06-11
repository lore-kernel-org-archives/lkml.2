Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab2FKVPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 17:15:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34351 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab2FKVPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 17:15:19 -0400
Message-ID: <4FD65FD4.4060705@zytor.com>
Date: Mon, 11 Jun 2012 14:15:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: rob@landley.net, tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bhelgaas@google.com
Subject: Re: [PATCH 1/2 v2] x86: add max_addr boot option
References: <4FD5AFF2.3040306@cn.fujitsu.com>
In-Reply-To: <4FD5AFF2.3040306@cn.fujitsu.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 01:44 AM, Wen Congyang wrote:
> Currently, the boot option max_addr is only supported on ia64 platform.
> We also need it on x86 platform.
> For example:
> There are two nodes:
>  NODE#0  address range 0x00000000 00000000 - 0x00010000 00000000
>  NODE#1  address range 0x00010000 00000000 - 0x00020000 00000000
> If we only want to use node0, we can specify the max_addr. The boot
> option "mem=" can do the same thing now. But the boot option "mem="
> means the total memory used by the system. If we tell the user
> that the boot option "mem=" can do this, it will confuse the user.
> So we need an new boot option "max_addr" on x86 platform.
> 

I fail to see what this does that cannot be done with the
since-long-existing memmap= option.  Could you address why memmap=
doesn't match your needs?

	-hpa

