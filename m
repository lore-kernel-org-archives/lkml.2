Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab0HCMcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 08:32:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756156Ab0HCMcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 08:32:10 -0400
Message-ID: <4C580BF9.6090706@suse.cz>
Date: Tue, 03 Aug 2010 14:30:49 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Roman Zippel <zippel@linux-m68k.org>,
        Aristeu Rozanski <aris@redhat.com>
Subject: Re: [PATCH v2 0/9] kconfig: introduce saveconfig and alldefconfig
 (+more)
References: <20100731212907.GA7554@merkur.ravnborg.org>
In-Reply-To: <20100731212907.GA7554@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.7.2010 23:29, Sam Ravnborg wrote:
> This is an update of patches previous posted.
> 
> Version 2 have addressed the following feedback:
> - Drop the idea of introducing allrandconfig (Michal, Randy)
> - Do more code refactoring (Michal)
> - Use long options in conf.c (Michal)
> - savedefconfig shall list symbols in same order as in .config (Uwe)
>  
> The major feature is the introduction of "make savedefconfig".
> 
> Make savedefconfig creates a minimal configuration
> as have been discussed recently and which is already
> done for arm and powerpc.
> savedefconfig utilise the knowledge kconfig has to do so
> much faster than the phyton script posted.
> [...]

Applied, thanks.

Michal
