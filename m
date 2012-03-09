Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149Ab2CIULm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:11:42 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:44078 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759000Ab2CIULi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 15:11:38 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1203091855350.2742@ionos>
References: <201203091437.50996.tvrtko.ursulin@onelan.co.uk> <alpine.LFD.2.02.1203091855350.2742@ionos>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Mar 2012 12:11:17 -0800
X-Google-Sender-Auth: dMLcVDzjXv5wOgIICrvEQ8XXn6k
Message-ID: <CA+55aFz5mt1LWDVVdPD3vsE4F1u8+Rz5j1fh69de0f5ae-cbNw@mail.gmail.com>
Subject: Re: udelay minimum delay guarantee and maximum supported delay?
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Glauber Costa <gcosta@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 11:55 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Make those variables explicitely u32 again, so this works for both 32
> and 64 bit.

Ack. Should I take this directly?

                          Linus
