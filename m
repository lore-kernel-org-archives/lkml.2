Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab2JVPPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:15:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45456 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2JVPPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:15:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAKgNAkiS3KXB943RngX119Wwb8RTN_6i1uKRcDrr5+hn20J1qg@mail.gmail.com>
References: <20120920233700.GA3363@www.outflux.net>
	<CAKgNAkiYpct9iHwVC38oOF4dRizCRu0v7gwbfv5sVV1gxomuKA@mail.gmail.com>
	<CAKgNAkiS3KXB943RngX119Wwb8RTN_6i1uKRcDrr5+hn20J1qg@mail.gmail.com>
Date: Mon, 22 Oct 2012 08:15:33 -0700
X-Google-Sender-Auth: 9TgaUWm-tN_c89kub3g3Vcb-iIo
Message-ID: <CAGXu5j+4e_NgSeUjSkFmewSzZLeiSVXcY0oCRxngmc83WWVKRg@mail.gmail.com>
Subject: Re: [RESEND][PATCH] prctl: update seccomp sections for mode 2 (BPF)
From: Kees Cook <keescook@chromium.org>
To: mtk.manpages@gmail.com
Cc: linux-man@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, wad@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 12:34 AM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> Kees,
>
> A couple of questions about SECCOMP_MODE_FILTER.
>
> I added some words that the arg3 is a pointer to 'struct fprog'. Can
> you confirmn that's correct?

Correct. Good idea to add this detail.

> If the CONFIG_SECCOMP_FILTER permits fork(), is the seccomp setting
> inherited across fork()? Similar question for execve().

Yes for both. Additionally, the filters are cumulative. (If the
filters allows prctl, additional filters can be appended; they are run
in order until the first non-allow result is seen.)

-Kees

-- 
Kees Cook
Chrome OS Security
