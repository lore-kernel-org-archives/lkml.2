Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2JCUyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 16:54:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57298 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab2JCUyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 16:54:43 -0400
MIME-Version: 1.0
In-Reply-To: <20121003204919.GA9092@outflux.net>
References: <CA+55aFw1Y5_HtfXh+-OEQ2KGpW0N18kA4O3R7=cv29_CaF+3UQ@mail.gmail.com>
 <20121003194614.GA2893@elliptictech.com> <20121003200515.GZ9092@outflux.net>
 <CA+55aFwgF1O_DzF0bqGO06n2kxNGE=f5BQsvZF_+q9o0pFPeGw@mail.gmail.com>
 <20121003204141.GB6026@thunk.org> <20121003204919.GA9092@outflux.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Oct 2012 13:54:21 -0700
X-Google-Sender-Auth: WOL6zgcPy7n3fd_t5W0srSHmEp0
Message-ID: <CA+55aFwXLXfAHHBEYYiz_4qjxWUpENECCZwFN_1gq+e48f+3Sw@mail.gmail.com>
Subject: Re: Linux 3.6
To: Kees Cook <kees@outflux.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Nick Bowler <nbowler@elliptictech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 1:49 PM, Kees Cook <kees@outflux.net> wrote:
>
> I think the benefits of this being on by default outweigh glitches
> like this. Based on Nick's email, it looks like a directory tree of his
> own creation.

I agree that *one* report like this doesn't necessarily mean that we
need to turn it off, if Nick is happy to just fix up his script and
it's all local.

However, I suspect we'll see more. And once that happens, we're not
going to keep a default that breaks peoples old scripts, and we're
going to have to rely on distributions (or users) explicitly setting
it.

Compatibility is just too important.

            Linus
