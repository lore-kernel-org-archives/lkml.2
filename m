Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750850Ab1L0FIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 00:08:17 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47915 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1L0FIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 00:08:11 -0500
MIME-Version: 1.0
In-Reply-To: <1324947731-22980-1-git-send-email-keithp@keithp.com>
References: <1324947731-22980-1-git-send-email-keithp@keithp.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 26 Dec 2011 21:07:49 -0800
X-Google-Sender-Auth: qqkXe7ZxgVe3__bS5qexow8gRwk
Message-ID: <CA+55aFyvTLg4WxvF-T3fOb9wTgAQGJoqVzNpr6ZyqynBH_ea8g@mail.gmail.com>
Subject: Re: [PATCH 0/2]: drm/i915: Disable RC6 and semaphores on SNB *again*
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 26, 2011 at 5:02 PM, Keith Packard <keithp@keithp.com> wrote:
> This leaves them enabled on IVB, but disables them on SNB as we've
> discovered (yet again) that there are hardware combinations that
> simply cannot run with them.

Oh well.

Applied,

               Linus
