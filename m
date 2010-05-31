Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab0EaOMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 10:12:21 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:39582 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab0EaOMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 10:12:19 -0400
X-Greylist: delayed 2224 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 May 2010 10:12:19 EDT
Date: Sun, 30 May 2010 22:32:12 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, hweight: Fix UML boot crash
Message-ID: <20100531023212.GA22673@c-98-229-117-200.hsd1.ma.comcast.net>
References: <201005271944.09541.toralf.foerster@gmx.de> <AANLkTimKwxYxM_PExplIDK1WPTQ9e_-CHn5SnIvfjfUg@mail.gmail.com> <20100530150214.GA1565@liondog.tnic> <201005301728.25976.toralf.foerster@gmx.de> <20100530170346.GC1565@liondog.tnic> <4C02B020.2040103@zytor.com> <20100530193956.GA2498@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100530193956.GA2498@liondog.tnic>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 30, 2010 at 09:39:56PM +0200, Borislav Petkov wrote:
> Which begs the question why _is_ UML sucking in x86 stuff and can anyone
> provide us with some sensible reasons? Because if there aren't any, it
> is their includes that should be fixed. Let me see what I can do to
> redirect hweight stuff properly...

Generally, UML pulls in the host arch headers because they work.  When
they are only architecture-dependent (and not, say, depending on the
host task struct or something), they're fine.

What's the include path from UML to the x86 hweight stuff?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
