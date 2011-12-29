Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab1L2REE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 12:04:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34109 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065Ab1L2REB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 12:04:01 -0500
Message-ID: <4EFC9DEC.40302@suse.cz>
Date: Thu, 29 Dec 2011 18:05:48 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kbuild: add target to install gzipped modules
References: <1325173819-26274-1-git-send-email-lucas.demarchi@profusion.mobi> <4EFC9872.7000708@suse.cz> <CAMOw1v5+6DOgjZAZ=YjYrp8geqwLpYu=e2SMY4V7+LYZAMMUeA@mail.gmail.com>
In-Reply-To: <CAMOw1v5+6DOgjZAZ=YjYrp8geqwLpYu=e2SMY4V7+LYZAMMUeA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 29.12.2011 17:55, Lucas De Marchi napsal(a):
> Sure, but it has the same problem of running depmod twice. I was
> thinking that compressed modules might be useful for others, not
> developing kmod. At least I know Archlinux uses gzipped modules by
> default and probably gentoo guys, too.

And what's the benefit to users of Archlinux / Gentoo? Do they also
compress libraries in /usr/lib? :)

Michal
