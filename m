Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab1HaOtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:49:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab1HaOtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:49:15 -0400
Message-ID: <4E5E49E9.40805@suse.cz>
Date: Wed, 31 Aug 2011 16:49:13 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: make silentoldconfig question
References: <CAC9WiBiVj7GSAE4WcJ5peniP1a53Cgmmjd=ZHjjqSMBT5EsXaA@mail.gmail.com>
In-Reply-To: <CAC9WiBiVj7GSAE4WcJ5peniP1a53Cgmmjd=ZHjjqSMBT5EsXaA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.8.2011 10:47, Francis Moreau wrote:
> Hello,
> 
> I'm a bit confused about silentoldconfig target since it doesn't
> really makes any differences with oldconfig.

silentoldconfig is a historical misnomer, nowadays oldconfig is silent
as well. The purpose of silentoldconfig is to generate include/config/*
and include/generated/autoconf.h files before build starts, oldconfig is
the user interface.

> The only difference I found is this one: if I add a new valid symbol
> at the end of my .config (therefore the position of the symbol is
> incorrect) then olconfig will recreate the .config and thus print its
> annoying message "# config written ..." to stdin whereas
> silentoldconfig won't print anything not because it's silent but
> beacuse the .config is not recreated so the symbol is still badly
> located at the end of the file.

Yes, silentoldconfig does not touch .config if no symbol changed. The
user interfaces always save the .config file.

Michal

