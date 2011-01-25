Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab1AYBQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:16:30 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37288 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1AYBQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:16:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lNjlkJj9aFL200WFrNUp2VdkuqMvGg18Q7eFAttmkb1bXLQX2pEuocKNpg3JRgTSXW
         evMVpD+3OabBHeooDjd4DeDFtyRhAlCstQ+W9S1mZPCp+Idb+Crcrg/XvN1FGAQohSsV
         MD585ZsCXwHAPSb92iMXQEBvsQ0V9mDhXb7Co=
MIME-Version: 1.0
In-Reply-To: <4086953399116e4d9a14f9fa1aa8cf33aaef753d.1295909909.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1295909908.git.jeremy.fitzhardinge@citrix.com>
	<4086953399116e4d9a14f9fa1aa8cf33aaef753d.1295909909.git.jeremy.fitzhardinge@citrix.com>
Date: Tue, 25 Jan 2011 12:16:27 +1100
Message-ID: <AANLkTimnpm8YdxgnqekMZUbYN=ZAdVy=C1HkY3uHNS2h@mail.gmail.com>
Subject: Re: [PATCH 6/6] x86/ticketlock: make __ticket_spin_trylock common
From: Nick Piggin <npiggin@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 10:41 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>
> Make trylock code common regardless of ticket size.

What's the asm for this look like?
