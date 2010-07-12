Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab0GLI7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 04:59:04 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53456 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab0GLI7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 04:59:01 -0400
Message-ID: <4C3AD94C.7070807@cs.helsinki.fi>
Date: Mon, 12 Jul 2010 11:58:52 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Yinghai Lu <yinghai.lu@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Setup early console as early as possible
References: <4C3A3B27.7020009@oracle.com>
In-Reply-To: <4C3A3B27.7020009@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

Yinghai Lu wrote:
> Analyze "console=uart8250,io,0x3f8,115200n8" in i386_start_kernel/x86_64_start_kernel,
> and call setup_early_serial8250_console() to init early serial console.
> 
> only can handle io port kind of 8250. because mmio need ioremap.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

What's the purpose of this patch? Does it make my early boot I/O patch 
obsolete?

			Pekka
