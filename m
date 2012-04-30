Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab2D3IDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 04:03:25 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58152 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab2D3IDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 04:03:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120430075417.GA8438@lizard>
References: <4F9E39F1.5030600@kernel.org>
	<CAOJsxLE3A3b5HSrRm0NVCBmzv7AAs-RWEiZC1BL=se309+=WTA@mail.gmail.com>
	<20120430075417.GA8438@lizard>
Date: Mon, 30 Apr 2012 11:03:23 +0300
X-Google-Sender-Auth: 0Nyz8IN4-QwDqVR80wBYsgJNVsI
Message-ID: <CAOJsxLHh8bD7hoqG8nkuaib63PC3kCvD6_2U4iBsCz1JLvZ+xQ@mail.gmail.com>
Subject: Re: vmevent: question?
From: Pekka Enberg <penberg@kernel.org>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Mon, Apr 30, 2012 at 10:54 AM, Anton Vorontsov
<cbouatmailru@gmail.com> wrote:
> It seems to be a pretty nice driver. Speaking of ABI, the only thing
> I personally dislike is VMEVENT_CONFIG_MAX_ATTRS (i.e. fixed-size
> array in vmevent_config)... but I guess it's pretty easy to make
> it variable-sized array... was there any particular reason to make
> the _MAX thing?

It made the implementation simpler but the ABI should support
variable-sized arrays. We can relax the limitation if necessary.

                         Pekka
