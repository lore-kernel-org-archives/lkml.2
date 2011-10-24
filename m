Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab1JXNxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:53:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37940 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab1JXNxS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:53:18 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1110242108540.19271@tundra.namei.org>
References: <alpine.LRH.2.00.1110242108540.19271@tundra.namei.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 24 Oct 2011 15:52:56 +0200
X-Google-Sender-Auth: tXzhvQ-9-Tqwss7qR2GA7a2kDbA
Message-ID: <CA+55aFxbh9eHYe8cPH2TaTW1t5C6C+z-Bcy+kGhR0Gt=MgMvcQ@mail.gmail.com>
Subject: Re: [GIT] Security subsystem updates for 3.2
To: James Morris <jmorris@namei.org>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 1:21 PM, James Morris <jmorris@namei.org> wrote:
>
> The most significant item here is the inclusion of EVM:
> https://lkml.org/lkml/2011/6/29/419
>
> There are also enhancements to Smack and Tomoyo, as well as general
> cleanups and fixes across the subsystem.
>
> Please pull.
>
> Jarkko Sakkinen (6):
>      Smack: domain transition protections (v3)

So this is reverted in linux-next. I don't know why, but it's a bad
sign. Doesn't compile?

                  Linus
