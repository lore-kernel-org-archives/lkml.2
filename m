Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab0G2KJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:09:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:37125 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab0G2KJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:09:12 -0400
Message-ID: <4C515318.40706@suse.cz>
Date: Thu, 29 Jul 2010 12:08:24 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roman Zippel <zippel@linux-m68k.org>,
        Uwe Kleine-Koig <u.kleine-koenig@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] kconfig: use long options in conf
References: <20100725213808.GA5814@merkur.ravnborg.org> <20100725214021.GD5834@merkur.ravnborg.org> <4C4EFE80.7050808@suse.cz> <20100728203622.GA32086@merkur.ravnborg.org> <4C51473A.4000605@suse.cz> <20100729093946.GA6725@merkur.ravnborg.org>
In-Reply-To: <20100729093946.GA6725@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.7.2010 11:39, Sam Ravnborg wrote:
> I had in mind to deprecate randconfig in favour of allrandconfig
> to get more consitency in the names.
> But I failed to document this in the changelog.
> 
> I can submit the following as a real patch if you agree.

To me it seems like a change for the sake of change :), but if you like
to have the targets named all*config consistenly, I'm OK with it.

Michal
