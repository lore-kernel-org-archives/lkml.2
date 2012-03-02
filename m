Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab2CBArp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 19:47:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58748 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab2CBArN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 19:47:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eric.dumazet@gmail.com designates 10.42.29.70 as permitted sender) smtp.mail=eric.dumazet@gmail.com; dkim=pass header.i=eric.dumazet@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120301233712.GS3990@outflux.net>
References: <1330559620-23543-1-git-send-email-wad@chromium.org>
	<20120301233712.GS3990@outflux.net>
Date: Thu, 1 Mar 2012 16:47:13 -0800
Message-ID: <CAL4WiipsJz5Nc8aqUgRgM0r3tA5p7W-DgATJNs8uKo0twr=iag@mail.gmail.com>
Subject: Re: [PATCH v12 01/13] sk_run_filter: add support for custom load_pointer
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: akpm@linux-foundation.org, sfr@canb.auug.org.au,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu,
        pmoore@redhat.com, corbet@lwn.net, markus@chromium.org,
        coreyb@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 1 mars 2012 15:37, Kees Cook <keescook@chromium.org> a écrit :
> Hi,
>
> So far, it looks like everyone who spoke up is satisfied with this patch
> series. Or their MUAs got caught up on a leap-year bug and missed the
> posting. ;)
>

Sorry for the delay, I only had time to review patch 01/13

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
