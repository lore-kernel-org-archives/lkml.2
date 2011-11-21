Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1KUR0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:26:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab1KUR0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:26:16 -0500
Message-ID: <4ECA89EB.2060604@suse.cz>
Date: Mon, 21 Nov 2011 18:27:07 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kbuild@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 1/8] kbuild: Add support for installing generated asm
 headers
References: <1321569446-20433-1-git-send-email-hpa@linux.intel.com> <1321569446-20433-2-git-send-email-hpa@linux.intel.com>
In-Reply-To: <1321569446-20433-2-git-send-email-hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 17.11.2011 23:37, H. Peter Anvin napsal(a):
> From: "H. Peter Anvin" <hpa@linux.intel.com>
> 
> Generated asm headers are supposed to live in
> arch/*/include/generated/asm, but objhdr-y expect them to live in the
> same directory they are generated in.  Instead of trying to cut that
> particular Gordian knot, introduce genhdr-y that takes this into
> account; the sole user of objhdr-y, linux/version.h, should be
> migrated over at some later date.
> 
> Suggested-by: David Woodhouse <dwmw2@infradead.org>
> Acked-by: David Woodhouse <dwmw2@infradead.org>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Michal Marek <mmarek@suse.cz>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

Acked-by: Michal Marek <mmarek@suse.cz>
