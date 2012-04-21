Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab2DUBFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 21:05:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39492 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab2DUBFx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 21:05:53 -0400
MIME-Version: 1.0
In-Reply-To: <1334967830-26624-1-git-send-email-john.stultz@linaro.org>
References: <1334967830-26624-1-git-send-email-john.stultz@linaro.org>
Date: Fri, 20 Apr 2012 18:05:51 -0700
Message-ID: <CAMP5XgcHg+haaYz+zamu+ue+rOPNgBg0zdMZvyim+pDGAEBnLQ@mail.gmail.com>
Subject: Re: [PATCH] [RFC] android-alarm: Switch from wakelocks to wakeup sources
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 5:23 PM, John Stultz <john.stultz@linaro.org> wrote:
> In their current AOSP tree, the Android in-kernel wakelock
> infrastructure has been reimplemented in terms of wakeup
> sources:
> http://git.linaro.org/gitweb?p=people/jstultz/android.git;a=commitdiff;h=e9911f4efdc55af703b8b3bb8c839e6f5dd173bb
>
> The Android alarm driver currently has stubbed out calls
> to wakelock functionality. So this patch simply converts
> the stubbed out wakelock calls to wakeup source calls, and
> removes the empty wakelock macros
>
> This is something I'd like to propose for staging, but wanted
> to get some input from Arve, Colin or other member of the
> Android team first.
>
> Thoughts or objections?
>

Looks reasonable to me.

-- 
Arve Hjønnevåg
