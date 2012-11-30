Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1769054Ab2K3TTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:19:06 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:42420 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030452Ab2K3TS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:18:59 -0500
MIME-Version: 1.0
In-Reply-To: <50B87082.3020604@broadcom.com>
References: <1354221910-22493-1-git-send-email-mcgrof@do-not-panic.com> <50B87082.3020604@broadcom.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 30 Nov 2012 11:18:37 -0800
X-Google-Sender-Auth: 03CYvO8T5Qf2KXdWDaMDxCoKNqg
Message-ID: <CAB=NE6UO8jPYOktteaLeihVqLp251-Q=jv5z_OThXoR+JtRKeg@mail.gmail.com>
Subject: Re: [PATCH 0/6] drivers: convert struct spinlock to spinlock_t
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        backports@vger.kernel.org, alexander.stein@systec-electronic.com,
        brudley@broadcom.com, rvossen@broadcom.com, frankyl@broadcom.com,
        kanyan@broadcom.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com, kyungmin.park@samsung.com,
        s.nawrocki@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        srinidhi.kasagar@stericsson.com, linus.walleij@linaro.org,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 12:38 AM, Arend van Spriel <arend@broadcom.com> wrote:
> So what is the rationale here. During mainlining our drivers we had to
> remove all uses of 'typedef struct foo foo_t;'. The Linux CodingStyle
> (chapter 5 Typedefs) is spending a number of lines explaining why.
>
> So is spinlock_t an exception to this rule simply because the kernel
> uses spinlock_t all over the place.

Yes.

  Luis
