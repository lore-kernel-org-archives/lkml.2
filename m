Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab1DDQBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 12:01:12 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:35559 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab1DDQBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 12:01:11 -0400
Message-ID: <4D99EB3E.1020202@grupopie.com>
Date: Mon, 04 Apr 2011 17:01:02 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Valdis.Kletnieks@vt.edu, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kbuild: move KALLSYMS_EXTRA_PASS from Kconfig to
 Makefile
References: <1301913651-9055-1-git-send-email-dedekind1@gmail.com>	 <1301913651-9055-2-git-send-email-dedekind1@gmail.com>	 <131611.1301921158@localhost> <1301921230.2760.79.camel@localhost>	 <7621.1301930536@localhost> <1301931464.2760.101.camel@localhost>
In-Reply-To: <1301931464.2760.101.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> On Mon, 2011-04-04 at 11:22 -0400, Valdis.Kletnieks@vt.edu wrote:
>> [...]
>> When was the last time we actually saw such a bug report?  I'm suspecting that
>> all the affected people just set the variable and get on with their lives.  So
>> we should either just make it automatic if that's what people are going to do,
>> or we rip the entire "EXTRA_PASS' stuff out forcibly and *make* people fix the
>> actual underlying issue that causes the extra pass to be needed...
> 
> I do not know when this bug was last seen, but I'd not remove this
> "extra pass" work around so far. WRT automatic fix-up - I do not have
> strong opinion here, but Paulo Marques pointed in another thread that
> due to various alignment issues the bug is tricky and may come back. So
> probably removing working code is not very wise. Thus, it seems the way
> I proposed in this patch is a good balance.
> 
> But anyway, if Michal Marek requests to change this, I'll do this (he is
> the Maintainer).

Doing a search on a mail archive for "Inconsistent kallsyms data"
results in a dozen or so threads, and the last one seems to be on alpha
in 2008.

Not very frequent for certain, but not in the "never been seen" category
either.

-- 
Paulo Marques - www.grupopie.com

"All I ask is a chance to prove that money can't make me happy."
