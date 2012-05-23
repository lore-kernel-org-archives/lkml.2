Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760574Ab2EWRH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:07:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55081 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2EWRH4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:07:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120523113432.GA12142@gmail.com>
References: <20120523113432.GA12142@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 May 2012 10:07:35 -0700
X-Google-Sender-Auth: iYCdpBdiSN64s6J08kYjkkD_5Uc
Message-ID: <CA+55aFzCDKK56CRXWXrPPtok84KJY4BbORcT3GfEH8xmOfgP6g@mail.gmail.com>
Subject: Re: [GIT PULL] x86/urgent fixes for v3.5
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 4:34 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Sasha Levin (1):
>      x86, printk: Add missing KERN_CONT to NMI selftest

Why? This seems to be garbage.

            Linus
