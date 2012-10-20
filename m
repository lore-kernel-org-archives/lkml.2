Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab2JTW6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 18:58:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55966 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab2JTW6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 18:58:52 -0400
Date: Sun, 21 Oct 2012 00:58:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Artem S. Tashkinov" <t.artem@lycos.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, security@kernel.org
Subject: Re: Re: A reliable kernel panic (3.6.2) and system crash when
 visiting a particular website
Message-ID: <20121020225849.GA8976@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Pavel Machek <pavel@ucw.cz>,
	"Artem S. Tashkinov" <t.artem@lycos.com>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	security@kernel.org
References: <2104474742.26357.1350734815286.JavaMail.mail@webmail05>
 <20121020162759.GA12551@liondog.tnic>
 <966148591.30347.1350754909449.JavaMail.mail@webmail08>
 <20121020203227.GC555@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121020203227.GC555@elf.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2012 at 10:32:28PM +0200, Pavel Machek wrote:
> On Sat 2012-10-20 17:41:49, Artem S. Tashkinov wrote:
> > On Oct 20, 2012, Borislav Petkov wrote: 
> > 
> > > Yeah, your kernel is tainted with a proprietary module (vbox*, etc). Can
> > > you reproduce your corruptions (this is what it looks like) without that
> > > module?
> > 
> > Yes, I can reproduce this panic with zero proprietary/non-free modules loaded.
> > 
> > The problem is the kernel doesn't even print a kernel panic - the
> > system just freezes completely - cursor in a text console stops
> > blinking.
> 
> bugtraq? :-).
> 
> If remote website can crash your Linux, that's quite significant news.
> 
> (Cc-ed netdev@ and security@ ... this may be important).

I don't think that's the problem - I rather suspect the fact that he's
using virtualbox which is causing random corruptions by writing to
arbitrary locations.

Artem,

please remove virtualbox completely from your system, rebuild the kernel
and make sure the virtualbox kernel modules don't get loaded - simply
delete them so that they are completely gone; *and* *then* retest again.

Thanks.

-- 
Regards/Gruss,
    Boris.
