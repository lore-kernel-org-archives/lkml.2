Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab2CBAGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 19:06:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41103 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910Ab2CBAGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 19:06:46 -0500
Message-ID: <4F500ECB.9090504@zytor.com>
Date: Thu, 01 Mar 2012 16:05:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: akpm@linux-foundation.org, sfr@canb.auug.org.au,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, mingo@redhat.com,
        oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net,
        mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu,
        eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org,
        scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com
Subject: Re: [PATCH v12 01/13] sk_run_filter: add support for custom load_pointer
References: <1330559620-23543-1-git-send-email-wad@chromium.org> <20120301233712.GS3990@outflux.net>
In-Reply-To: <20120301233712.GS3990@outflux.net>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2012 03:37 PM, Kees Cook wrote:
> Hi,
> 
> So far, it looks like everyone who spoke up is satisfied with this patch
> series. Or their MUAs got caught up on a leap-year bug and missed the
> posting. ;)
> 
> Is it time to pull this into -next so more people can feel it? I brought
> Andy Lutomirski's patches forward (needed to bump the prctl values), and
> updated my git tree. If we're ready, here it is in all its request-pull
> format glory:
> 

Acked-by: H. Peter Anvin <hpa@zytor.com>

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

