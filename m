Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab2JVVns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:43:48 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55606 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab2JVVnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:43:46 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAGXu5j+4e_NgSeUjSkFmewSzZLeiSVXcY0oCRxngmc83WWVKRg@mail.gmail.com>
References: <20120920233700.GA3363@www.outflux.net> <CAKgNAkiYpct9iHwVC38oOF4dRizCRu0v7gwbfv5sVV1gxomuKA@mail.gmail.com>
 <CAKgNAkiS3KXB943RngX119Wwb8RTN_6i1uKRcDrr5+hn20J1qg@mail.gmail.com> <CAGXu5j+4e_NgSeUjSkFmewSzZLeiSVXcY0oCRxngmc83WWVKRg@mail.gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 22 Oct 2012 23:43:25 +0200
Message-ID: <CAKgNAkjBqGn7xnncCvZ3NAUZWPWuNSDA_791s--mu_XFfJCAcQ@mail.gmail.com>
Subject: Re: [RESEND][PATCH] prctl: update seccomp sections for mode 2 (BPF)
To: Kees Cook <keescook@chromium.org>
Cc: linux-man@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, wad@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> If the CONFIG_SECCOMP_FILTER permits fork(), is the seccomp setting
>> inherited across fork()? Similar question for execve().
>
> Yes for both. Additionally, the filters are cumulative. (If the
> filters allows prctl, additional filters can be appended; they are run
> in order until the first non-allow result is seen.)

Thanks. I'll add some words to the man page.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
