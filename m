Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab2GPTsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 15:48:01 -0400
Received: from unicorn.mansr.com ([78.86.181.103]:60646 "EHLO
	unicorn.mansr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab2GPTr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 15:47:58 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Mikael Pettersson <mikpe@it.uu.se>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
	<20472.466.594018.973876@pilspetsen.it.uu.se>
	<20120710101223.GF15120@arm.com> <20120714093505.GB23316@elf.ucw.cz>
	<20120715113631.GA10597@arm.com> <20120716161913.GB20549@elf.ucw.cz>
Date: Mon, 16 Jul 2012 20:47:57 +0100
In-Reply-To: <20120716161913.GB20549@elf.ucw.cz> (Pavel Machek's message of
	"Mon, 16 Jul 2012 18:19:13 +0200")
Message-ID: <yw1xr4sbbi8i.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> Hi!
>
>> The assembly syntax is very reasonable already and not far from what we
>> are used to (see the .S files in my kernel patches). The 64-bit
>> instructions are different and that's specified here (apart from the
>> actual bit encoding):
>> 
>> http://infocenter.arm.com/help/topic/com.arm.doc.genc010197a/index.html
>
> "This document is only available in a PDF version to registered ARM
> customers."
>
> It would be nice to make this public :-(.

Anyone can register, so it's not all that bad.

-- 
Måns Rullgård
mans@mansr.com
