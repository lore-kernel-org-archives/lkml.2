Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab2JPVhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 17:37:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55144 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab2JPVhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 17:37:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAAZUjxD8-kA5325+OT0tANi0vUwcSRwT+VYaEd2LZ9cJrw0xUA@mail.gmail.com>
References: <CAAZUjxCvK0QnwnZP_FBiO2JM1rMoEA3HLjKAcYD14cxdGWyg4Q@mail.gmail.com>
 <507DB47E.5090003@mit.edu> <CAAZUjxAPAUD50asniJVNgD3X=vM_d=GPKJ5C2eVGo6r4HUKYLQ@mail.gmail.com>
 <CALCETrVKiO5t8AuEM=XxdPgZGr6crr6C-4174607_VLO787--g@mail.gmail.com> <CAAZUjxD8-kA5325+OT0tANi0vUwcSRwT+VYaEd2LZ9cJrw0xUA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 16 Oct 2012 14:36:47 -0700
Message-ID: <CALCETrUHWfxMK0qh79Uh4nb62BCmR_bnfG2rOZdanO+zkueN=A@mail.gmail.com>
Subject: Re: VDSO gettimeofday() x86_64 linux 3.2
To: wilson self <wself00@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 12:43 PM, wilson self <wself00@gmail.com> wrote:
> I am just using gcc timetest.c -o timetest
>
> Should be dynamically linked. glibc is 2.5, which is quite old, but I
> think this should still work with it, no?

You need at least glibc 2.7 for this to work well on modern kernels.
FWIW, glibc 2.7 is five years old.

--Andy
