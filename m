Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab1GXI4H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 04:56:07 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:41075 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab1GXI4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 04:56:01 -0400
MIME-Version: 1.0
In-Reply-To: <20110724072729.GA21281@elte.hu>
References: <CAGq3pz4VHgagUQ+jGJdt9LL4UnFt+CDgcLLXbuVeKfWMc=0wAA@mail.gmail.com>
	<20110724072729.GA21281@elte.hu>
Date: Sun, 24 Jul 2011 09:55:59 +0100
X-Google-Sender-Auth: NYNEZdfR59Q-dE_bDvFzE9NZrnc
Message-ID: <CAGq3pz6zGhFCgpeWy2zfWw_fNv2UFz=51uL9cfjArggu=wztcw@mail.gmail.com>
Subject: Re: OLPC power management patches - merge for 3.1?
From: Daniel Drake <dsd@laptop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, Andres Salomon <dilinger@queued.net>,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 July 2011 08:27, Ingo Molnar <mingo@elte.hu> wrote:
> it's excluded because in testing i found a boot crash with it.
> Thomas did a quick fix for it but i have not heard about it since
> then - Thomas/Peter, is this all resolved in x86/olpc?

Ah, sorry if we broke something. Can you go into more details on the
crash? We haven't heard anything on these lines. I'm willing to help
out fixing it.

Is it related to the apbuart serial patch you included in your mail? I
don't see how that could have been affected by OLPC patches - but I am
probably missing something.

> (There's also the build failure Randy reported.)

Thanks for reporting, I'll send a patch to fix that shortly.

Thanks!
Daniel
