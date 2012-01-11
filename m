Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229Ab2AKQNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:13:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60165 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757683Ab2AKQNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:13:21 -0500
MIME-Version: 1.0
In-Reply-To: <CALLzPKaSmpKot=bgm7qQ8a7J4-sxXLsMPrHz6Pe0SyzWpZp-yQ@mail.gmail.com>
References: <alpine.LRH.2.00.1201091252220.18816@tundra.namei.org>
 <CA+55aFwD2-bhd32L1SsjPQrpwOBhBdxTUaOj=oXN24vPwc+Wsg@mail.gmail.com>
 <alpine.LRH.2.00.1201111834570.2966@tundra.namei.org> <CA+55aFxecGt54RG3EX+LTQQx6ZXzYLOMRdgRmXTRDaD54JAVGg@mail.gmail.com>
 <CALLzPKaSmpKot=bgm7qQ8a7J4-sxXLsMPrHz6Pe0SyzWpZp-yQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Jan 2012 08:12:59 -0800
X-Google-Sender-Auth: feWJgF2MdC7mFWrNM9KDXFYH8E0
Message-ID: <CA+55aFwo=gL6LG-r5qaYTH+zu11_k7c36mtXrXEqLdF0UOG_LA@mail.gmail.com>
Subject: Re: [GIT] Security subsystem updates for 3.3
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 7:15 AM, Kasatkin, Dmitry
<dmitry.kasatkin@intel.com> wrote:
>
> Would just DIGITAL_SIGNATURE be enough?

I'm certainly ok with that too. It still clearly talks about what it
is, rather than become something only somebody "in the know" knows
what it means.

                   Linus
