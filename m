Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab2CGJqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 04:46:42 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43041 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2CGJqi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 04:46:38 -0500
MIME-Version: 1.0
In-Reply-To: <20120307024306.GA18493@windriver.com>
References: <20120307024306.GA18493@windriver.com>
Date: Wed, 7 Mar 2012 10:46:37 +0100
X-Google-Sender-Auth: EXM0fmRVIWqcRzmXS6LAnWpwn3g
Message-ID: <CAMuHMdXMqb17fSFoqu7BTGMGHBpy4xLAy2PjmrKd1pCKnsx+-Q@mail.gmail.com>
Subject: Re: linux-next: triage for March 6, 2012
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 03:43, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> Due to the nature of the commits I've been making lately, when I see
> a fail in linux-next, I have to wonder if I somehow caused it by a
> header shuffle.  After pouring over the kisskb linux-next results,
> I realized that I can't be the only one doing this, and that a triage
> summary of the linux-next fails should in theory be useful to a
> bunch of people doing similar to what I do.

Indeed. Unfortunately I don't have the bandwidth to do daily regression
summaries for linux-next, like I do for Linus' releases.

I haven't uploaded my scripts to kernel.org after the resurrection,
but you may be able to get linux-log-diff.pl and linux-log-summary.pl
from an old mirror.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
