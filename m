Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab2JCU3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 16:29:39 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56642 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab2JCU3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 16:29:37 -0400
MIME-Version: 1.0
In-Reply-To: <20121003200515.GZ9092@outflux.net>
References: <CA+55aFw1Y5_HtfXh+-OEQ2KGpW0N18kA4O3R7=cv29_CaF+3UQ@mail.gmail.com>
 <20121003194614.GA2893@elliptictech.com> <20121003200515.GZ9092@outflux.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Oct 2012 13:29:15 -0700
X-Google-Sender-Auth: 6-81Yg--wG3ggAQPvLcalvn2S-U
Message-ID: <CA+55aFwgF1O_DzF0bqGO06n2kxNGE=f5BQsvZF_+q9o0pFPeGw@mail.gmail.com>
Subject: Re: Linux 3.6
To: Kees Cook <kees@outflux.net>
Cc: Nick Bowler <nbowler@elliptictech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 1:05 PM, Kees Cook <kees@outflux.net> wrote:
>
> 3.6 introduced link restrictions:

Hmm. If this causes problems for others, I suspect we need to turn it
off by default.

It's a nice security thing, but considering how quickly people started
complaining after 3.6 was out, I suspect we'll see more of these, and
we may not have any choice.

             Linus
