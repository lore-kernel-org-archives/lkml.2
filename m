Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab2GaQVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:21:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39526 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab2GaQVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:21:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120731141536.GA4262@osiris.boeblingen.de.ibm.com>
References: <20120731141536.GA4262@osiris.boeblingen.de.ibm.com>
Date: Tue, 31 Jul 2012 09:21:05 -0700
X-Google-Sender-Auth: 1KrcGz1cSz-nTE6ZzvcKy4YIGLo
Message-ID: <CAGXu5j+PAk4xbcr=3=O4qBD=+1++i1DeE=TX5S9vT3UivcR72w@mail.gmail.com>
Subject: Re: [PATCH] samples/seccomp: fix endianness bug in LO_ARG define
From: Kees Cook <keescook@chromium.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Will Drewry <wad@chromium.org>, James Morris <james.l.morris@oracle.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 7:15 AM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>
> The LO_ARG define needs to consider endianness also for 32 bit builds.
>
> The "bpf_fancy" test case didn't work on s390 in 32 bit and compat mode
> because the LO_ARG define resulted in a BPF program which read the upper
> halve of the 64 bit system call arguments instead of the lower halves.
>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Good catch; thanks for the fix!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
