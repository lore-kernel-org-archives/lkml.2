Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab2IQKAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:00:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63925 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab2IQKAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:00:52 -0400
Date: Mon, 17 Sep 2012 12:00:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: tglx@linutronix.de, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [tip:x86/asm] x86: Prefer TZCNT over BFS
Message-ID: <20120917100046.GA32463@gmail.com>
References: <504DEA1B020000780009A277@nat28.tlf.novell.com>
 <tip-5870661c091e827973674cc3469b50c959008c2b@git.kernel.org>
 <CA+55aFxs3FUETs830p-ow29RDibu9=d77gxqaueX-wZyr8-40A@mail.gmail.com>
 <5056F04B020000780009BAF9@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5056F04B020000780009BAF9@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@suse.com> wrote:

> >>> On 14.09.12 at 23:14, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Thu, Sep 13, 2012 at 11:23 PM, tip-bot for Jan Beulich
> > <JBeulich@suse.com> wrote:
> >>
> >> x86: Prefer TZCNT over BFS
> > 
> > This patch is insane.
> 
> I'm not going to defend this simple and strait forward a patch 
> to such a reply, so Ingo, just drop it to please Linus, even 
> though I can't see what's _this_ bad about it.

Well, the problem is the complication of the dependencies, which 
obscures the logic and makes it hard to maintain going forward.

Linus's suggestion is to introduce CONFIG_X86_TZCNT as an add-on 
patch that cleans up and documents what this is all about.

Would you be willing to do such a patch?

Thanks,

	Ingo
