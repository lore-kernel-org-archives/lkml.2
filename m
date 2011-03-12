Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab1CLK2T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 05:28:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61371 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab1CLK2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 05:28:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=tb5zfNlmpdZb/m2Zv0at9XL9hPJKktg/hhqW4rxkUJveqR0FEH62zh7PdPHfyRlnvO
         Grh3BKpbUpb1sfhewtakm082OLKSl1vTQK9JIKc5ZXavMaoHxNZrMCP2q8V96oHW2s98
         UC7+qN6TrLCXpwOAu87FNZ2EeNCb7atsJe0Kw=
Message-ID: <4D7B4ABC.2050608@gmail.com>
Date: Sat, 12 Mar 2011 12:28:12 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Icedove/3.1.7
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.38-rc8
References: <AANLkTimG-1nSZw3P5q7LQbGmQch3ibsMPQ_duhAjhtQH@mail.gmail.com>
In-Reply-To: <AANLkTimG-1nSZw3P5q7LQbGmQch3ibsMPQ_duhAjhtQH@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-08 07:40, Linus Torvalds wrote:
> So please keep testing,

Doesn't build:
arch/x86/kernel/entry_64.S: Assembler messages:
arch/x86/kernel/entry_64.S:1531: Error: .size expression does not
evaluate to a constant
make[2]: *** [arch/x86/kernel/entry_64.o] Error 1
make[1]: *** [arch/x86/kernel] Error 2
make: *** [arch/x86] Error 2

Must be due to recent binutils upgrade, because 2.6.37 doesn't build
anymore either.

Looks like these patches are needed:
http://git.kernel.org/?p=linux/kernel/git/hjl/linux-2.6.37.y.git;a=commitdiff;h=2c5ce9c1b8eb927c131a31d4466e24e00647e9cb
https://patchwork.kernel.org/patch/606241/

Best regards,
--Edwin
