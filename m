Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab1E0TIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 15:08:16 -0400
Received: from mail.perches.com ([173.55.12.10]:2139 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab1E0TIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 15:08:10 -0400
Subject: Re: [patch v4] checkpatch: Signature format verification
From: Joe Perches <joe@perches.com>
To: Manish Kumar Singh <man.k1983@gmail.com>
Cc: anish <anish198519851985@gmail.com>, davej@redhat.com, rostedt@goodmis.org,
        apw@shadowen.org, akpm@linux-foundation.org, vapier@gentoo.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTikfh_ABGomn-Lm9Ugc7MzeRodwiEQ@mail.gmail.com>
References: <1306006721.1622.18.camel@anish-desktop>
	 <1306059528.2761.3.camel@anish-desktop>
	 <1306164094.2292.25.camel@anish-desktop>
	 <1306519311.1918.12.camel@anish-desktop>
	 <1306520991.31864.9.camel@Joe-Laptop>
	 <BANLkTikfh_ABGomn-Lm9Ugc7MzeRodwiEQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 12:08:08 -0700
Message-ID: <1306523288.31864.29.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-28 at 00:28 +0530, Manish Kumar Singh wrote:
> On Fri, May 27, 2011 at 11:59 PM, Joe Perches <joe@perches.com> wrote:
[]
>         8 bit chars, digits?
> What is 8 bit char...could you describe it?

An ascii char with the high order bit set.
Any char from 128 to 255.

[]

>         For the 3rd time, please use this form:
>                if ($line =~ /^(\s*)($ValidSignatures)(\s*)(.*)$/i) {
>         and if you really want email format validation,
>         use a separate function.

[]

> Problem with your way of doing is if anyone misses space between
> "sign" & name,
> the regular expression (/^(\s*)($ValidSignatures)(\s*)(.*)$/i )
> doesn't match

That's incorrect.  Try it.


