Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409Ab1FBLaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 07:30:30 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33814 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab1FBLa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 07:30:29 -0400
Message-ID: <4DE7741B.7040507@mvista.com>
Date: Thu, 02 Jun 2011 15:29:31 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: ralf@linux-mips.org
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mips@linux-mips.org, Russell King <linux@arm.linux.org.uk>,
        x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [patch 12/14] i8253: Move remaining content and delete <asm/i8253.h>
References: <20110601180456.801265664@duck.linux-mips.net> <20110601180610.913463093@duck.linux-mips.net>
In-Reply-To: <20110601180610.913463093@duck.linux-mips.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01-06-2011 22:05, ralf@linux-mips.org wrote:

> There is no really good other place but one line for two out of three
> architectures that have a <asm/i8253.h> file doesn't justify this files
> existence.

    I couldn't parse that. :-)

> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> To: linux-kernel@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-mips@linux-mips.org
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org

WBR, Sergei
