Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab0G1Plx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 11:41:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:59083 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab0G1Plv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 11:41:51 -0400
Message-ID: <4C504FBB.3020600@suse.cz>
Date: Wed, 28 Jul 2010 17:41:47 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: trapdoor6@gmail.com
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>, trivial@kernel.org,
        Nir Tzachar <nir.tzachar@gmail.com>
Subject: Re: Small typo in kernel [current source from git] .config option
References: <AANLkTi=ON+60QM9Ooepwr7FLr+RV1TN6X-6D78tuNfCS@mail.gmail.com>	<20100727165549.GC26649@merkur.ravnborg.org>	<AANLkTimmLLJ9VrbD94GA3ZH2XvBwEAAcrrL_etWAoEea@mail.gmail.com>	<4C500E41.40708@suse.cz> <AANLkTi=rPP7OfoNoyVkM0XR08ns6p0+cENzcdk7gY8TE@mail.gmail.com>
In-Reply-To: <AANLkTi=rPP7OfoNoyVkM0XR08ns6p0+cENzcdk7gY8TE@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Nir, who wrote nconfig, to CC).

On 28.7.2010 14:17, trapDoor wrote:
> On Wed, Jul 28, 2010 at 12:02 PM, Michal Marek <mmarek@suse.cz> wrote:
>> respectively). Unfortunatelly, there doesn't seem to be a way to
>> highlight single letters in an ncurses menu, hence the strange
>> cApitalization :(.
> 
> I wonder how is this resolved in other console applications such as
> Midnight Commander. Does it have its own implementation for
> highlighting characters (it uses coloured mnemonics e.g. in menus) or
> it's based on some common Linux/Unix library which perhaps could be
> used for the nconfig as well?

The problem is that nconfig uses the higher-level ncurses libraries
libmenu and libpanel, which make some things easier, but aren't as
flexible as using ncurses directly. Patches are welcome of course :-).

Michal
