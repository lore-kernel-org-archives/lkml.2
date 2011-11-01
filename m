Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab1KAVFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:05:16 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50873 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1KAVFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:05:14 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1111020735080.11087@tundra.namei.org>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
	<alpine.LRH.2.00.1111020735080.11087@tundra.namei.org>
Date: Tue, 1 Nov 2011 14:05:13 -0700
X-Google-Sender-Auth: Qa0UAx7uZBcrH51OwLKlCjZNNCo
Message-ID: <CAGXu5jJUZoKksT3AY3fF9Nt66FL+6mDbmUnYVGVChpeV=UT_2g@mail.gmail.com>
Subject: Re: [PATCH v6 0/3] security: Yama LSM
From: Kees Cook <keescook@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 1, 2011 at 1:45 PM, James Morris <jmorris@namei.org> wrote:
> On Wed, 26 Oct 2011, Kees Cook wrote:
>
> > As discussed at the Linux Security Summit, I'm resubmitting this
> > code. As an LSM, it has coherent policy around expanding specific DAC
> > behaviors. There is no need for it to be a full-blown MAC, since it is
> > not intended to be one, but rather to be a simplified expansion to DAC,
> > with system-wide knobs. See the specific patches for details...
>
> Yes, there was a strong consensus (unanimous I believe) at the security
> summit on incorporating the Yama LSM as a container for generally useful
> miscellaneous security hardening features that don't belong elsewhere.
>
> This means that LSM is no longer 'officially' only for access control
> mechanisms.

That would be very welcome.

> We probably need to flesh out criteria for inclusion in Yama and document
> it.

What's the best way for me to help with that documentation?

Thanks,

-Kees

--
Kees Cook
ChromeOS Security
