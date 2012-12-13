Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab2LMX3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 18:29:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40601 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab2LMX3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 18:29:16 -0500
Message-ID: <50CA6478.20008@zytor.com>
Date: Thu, 13 Dec 2012 15:27:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 19/27] x86, boot: update comments about entries for
 64bit image
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org> <1355436141-8668-20-git-send-email-yinghai@kernel.org>
In-Reply-To: <1355436141-8668-20-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 02:02 PM, Yinghai Lu wrote:
> +	 * If we come here from a bootloader, kernel(text+data+bss+brk),
> +	 * ramdisk, zero_page, command line could be above 4G.
> +	 * We depend on an identity mapped page table being provided
> +	 * that maps our entire kernel(text+data+bss+brk), and hopefully
> +	 * all of memory.

We should make it explicit what we depend on.  We certainly *can* depend
only on text+data+bss+brk ... with the dynamic page table approach we
can do that, and that would be most conservative; if we depend on other
things we should make that explicit, not just here but in boot.txt.

	-hpa


