Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab0K1Iro (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 03:47:44 -0500
Received: from solo.fdn.fr ([80.67.169.19]:58248 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab0K1Irl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 03:47:41 -0500
Date: Sun, 28 Nov 2010 09:47:38 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: microcai <microcai@fedoraproject.org>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linuxconsole-dev@lists.sourceforge.net
Subject: Re: [PATCH] Kernel fbcon UNICODE font support
Message-ID: <20101128084738.GH10602@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Vojtech Pavlik <vojtech@suse.cz>,
	microcai <microcai@fedoraproject.org>, linux-kernel@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linuxconsole-dev@lists.sourceforge.net
References: <1290750825.2372.59.camel@cai.gentoo> <20101127125742.GD4865@const.famille.thibault.fr> <AANLkTikfS+c93skkUFNLVJNah0DsjAUPE2jFNAQCAnCg@mail.gmail.com> <20101128081528.GA20705@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101128081528.GA20705@suse.cz>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vojtech Pavlik, le Sun 28 Nov 2010 09:15:28 +0100, a écrit :
> On Sun, Nov 28, 2010 at 02:50:49PM +0800, microcai wrote:
> > 2010/11/27 Samuel Thibault <samuel.thibault@ens-lyon.org>:
> > I did more work,and found that , VGA console (non framebuffer) realy
> > need 8bit/8bit attrib/char , because that's how text mode VGA cards
> > interpreter them. changing to full type will break VGA drivers.
> 
> Well, on VGA you could use the 512 glyphs available (9 bit character, 7
> bit attribute) and dynamically change the font in the video memory to
> always contain the characters that you need on the screen. Chances are
> that you won't need all 512 at any single time. The screen isn't that
> large in classic VGA mode.

That's what the Hurd console does indeed, and that's indeed enough to be
able to display all Debian Installer's dialog boxes in chinese without
problems :)

> But since VGA is mostly dead these days anyway, it'd be a neat hack, but
> probably not worth the effort.

Agreed, considering how bug prone it'd be.

Samuel
