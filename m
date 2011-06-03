Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1FCIZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 04:25:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab1FCIZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 04:25:49 -0400
Message-ID: <4DE89A8A.8070405@suse.cz>
Date: Fri, 03 Jun 2011 10:25:46 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roman Zippel <zippel@linux-m68k.org>, Waldo Bastian <bastian@kde.org>,
        Ryan Lortie <desrt@desrt.ca>,
        Lennart Poettering <lennart@poettering.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Heads-up: Linux make menuconfig .config vs. XDG_CONFIG_HOME ~/.config/
 clash - perhaps resolve it while 3.0 appears?
References: <20110602182431.GA26282@rhlx01.hs-esslingen.de>
In-Reply-To: <20110602182431.GA26282@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.6.2011 20:24, Andreas Mohr wrote:
> I just discovered a Linux kernel make menuconfig .config file
> accidentally situated in the home directory of a shell account
 > [...]
> "$XDG_CONFIG_HOME defines the base directory relative to which user
> specific configuration files should be stored. If $XDG_CONFIG_HOME is
> either not set or empty, a default equal to $HOME/.config should be
> used."

PEBKAC :-). BTW, did you really run into such problem yourself, or is it 
more a "what if"?


> It may thus be strongly advisable to rename the default name of the
> make menuconfig kernel .config file (perhaps .config_lx / .config_linux ?)
> to completely sidestep such a (mostly user-triggered)
> problematic clash in future.

No. The name ".config" is documented in the linux source as well as so 
many howtos and books, that we should not change it just for the fun of 
it. Arguably, a non-dot filename might have been a better choice, but 
".config" has been chosen, so we have to live with it.


> And (I cannot help but think of this) now that lx 3.0 is in -rc
> this might still be an especially appropriate moment to do it ;)

Linus made it clear that 3.0 is just a change in versioning, not an 
excuse for doing incompatible changes. (Incompatible changes can 
possibly happen in any release, but they need to be justified and need 
to be ready *before* -rc1.)

Michal
