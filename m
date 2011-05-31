Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab1EaCdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 22:33:38 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:59307 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab1EaCdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 22:33:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=cpgf9HZy2ZlwE+YN/wmB3jb8mKlLROlvUrSz9BlmA33oMobhWhHHG+o6KJtAF9l8+r
         2coWskvl0V7luEIcEqTspNvVf9Fe0USXMvhbee6e9QHtMwxDBECV/VvhVxjef3aru/FR
         A6qcEZlQ94RjHo1UEC2BC04PcoZvDnZmSXZPE=
MIME-Version: 1.0
In-Reply-To: <20110529191924.GD9835@elte.hu>
References: <cover.1306517576.git.luto@mit.edu> <20110529191924.GD9835@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 30 May 2011 22:33:17 -0400
X-Google-Sender-Auth: mOPH0Lzb8dyQrE5_6JY4-UeekmY
Message-ID: <BANLkTin9xfS_X9Bscf1qnNZMK=JBgpzV8Q@mail.gmail.com>
Subject: Re: [PATCH 0/5] x86-64: Remove syscall instructions at fixed addresses
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 3:19 PM, Ingo Molnar <mingo@elte.hu> wrote:
> Btw., do you know CONFIG_X86_PTDUMP=y and /debug/kernel_page_tables?
> You could use that to double check that after your patches all
> executable (and fixed address) pages are removed [or are harmless].

Done.  Now there's only one user-executable page and it's mostly harmless.

Maybe I'll try to get rid of vread_tsc and vread_hpet later on to make
it even more harmless.

--Andy
