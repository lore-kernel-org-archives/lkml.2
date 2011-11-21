Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab1KUR1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:27:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048Ab1KUR1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:27:10 -0500
Message-ID: <4ECA8A21.8000409@suse.cz>
Date: Mon, 21 Nov 2011 18:28:01 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kbuild@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 7/8] checksyscalls: Use arch/x86/syscalls/syscall_32.tbl
 as source
References: <1321569446-20433-1-git-send-email-hpa@linux.intel.com> <1321569446-20433-8-git-send-email-hpa@linux.intel.com>
In-Reply-To: <1321569446-20433-8-git-send-email-hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 17.11.2011 23:37, H. Peter Anvin napsal(a):
> From: "H. Peter Anvin" <hpa@linux.intel.com>
> 
> Use the new arch/x86/syscalls/syscall_32.tbl file as source instead of
> arch/x86/include/asm/unistd_32.h.
> 
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

Acked-by: Michal Marek <mmarek@suse.cz>
