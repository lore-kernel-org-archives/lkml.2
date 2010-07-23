Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab0GWJ0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 05:26:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867Ab0GWJZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 05:25:58 -0400
Message-ID: <4C49601E.5060605@suse.cz>
Date: Fri, 23 Jul 2010 11:25:50 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Stephen Boyd <bebarino@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nir Tzachar <nir.tzachar@gmail.com>
Subject: Re: [PATCH] nconfig: Fix segfault when help contains special characters
References: <1279868654-15743-1-git-send-email-bebarino@gmail.com>
In-Reply-To: <1279868654-15743-1-git-send-email-bebarino@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.7.2010 09:04, Stephen Boyd wrote:
> nconfig segfaults when help text contains the character '%'. For a quick
> example, navigate to the kernel compression options and get the help for
> bzip2. Doing so triggers a call to mvwprintw() with a string containing
> '%' and no extra arguments to fill in the specifier's value. Fix this
> case by printing the literal string retrieved from the kconfig.

Thanks, applied.

Michal
