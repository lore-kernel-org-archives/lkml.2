Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750792Ab2LCFAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 00:00:46 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:63002 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2LCFAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 00:00:44 -0500
Date: Mon, 3 Dec 2012 13:00:33 +0800
From: Wang YanQing <udknight@gmail.com>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, mmarek@suse.cz, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, bp@alien8.de, sakiwit@gmail.com,
        lacombar@gmail.com, lucas.demarchi@profusion.mobi, dave@gnu.org,
        paul.gortmaker@windriver.com, crquan@gmail.com, bpoirier@suse.de
Subject: Re: [PATCH v4]menuconfig: Add Save button
Message-ID: <20121203050033.GB3856@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	"Yann E. MORIN" <yann.morin.1998@free.fr>,
	linux-kbuild@vger.kernel.org, mmarek@suse.cz,
	linux-kernel@vger.kernel.org, rdunlap@xenotime.net, bp@alien8.de,
	sakiwit@gmail.com, lacombar@gmail.com,
	lucas.demarchi@profusion.mobi, dave@gnu.org,
	paul.gortmaker@windriver.com, crquan@gmail.com, bpoirier@suse.de
References: <20121201161316.GA15246@udknight>
 <201212021852.51113.yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201212021852.51113.yann.morin.1998@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yann, All,
	
On Sun, Dec 02, 2012 at 06:52:50PM +0100, Yann E. MORIN wrote:
> To make the behavior consistent, may I suggest that you push the
> concept even a bit further:
>   - add a "Load" *and* a "Save" buttons
>   - get rid of the top-level "Load an Alternate Configuration File"
>     and "Save an Alternate Configuration File" entries
> 
> For the "Save" and "Load" buttons, please mimick how the nconf frontend
> behaves: prompt for the file to save to/load from, and prefill it with
> the last filename that was entered (".config" per default).
> 
> Of course, two patches for that: one for the "Save/Load" buttons, one
> to get rid of the top-level entries afterward.
Thanks, very good suggestion, I will jump in.

> Note: I do not state that your use-case is valid or not. That's your
> call how you configure and test your kernel. However, I think that
> having a consistent behavior across the frontends is a very nice goal
> to pursue.
I understand, I make a mistake in the comment in previous Email.

> See other comments in-lined, below.
> 
> > V1-V2: Rewrite the most code to make it more correct
> > V2-V3: Fix the behavior of conf_message_callback when exit.
> > V3-V4:
> > 1: Move Buttons a little left to make them look like symmetrical.
> > 2: Exchange the position between Save button and Exit button.
> > 3: Use conf_save instead of conf_write to make we can save
> > an alternate configuration file with Save button.
> > 
> > Signed-off-by: Wang YanQing <udknight@gmail.com>
> > ---
> >  scripts/kconfig/lxdialog/menubox.c | 21 +++++++++---------
> >  scripts/kconfig/mconf.c            | 45 ++++++++++++++++++++++++++++++--------
> >  2 files changed, 47 insertions(+), 19 deletions(-)
> > 
> > diff --git a/scripts/kconfig/lxdialog/menubox.c b/scripts/kconfig/lxdialog/menubox.c
> > index 1d60473..b445bda 100644
> > --- a/scripts/kconfig/lxdialog/menubox.c
> > +++ b/scripts/kconfig/lxdialog/menubox.c
> > @@ -26,7 +26,7 @@
> >   *
> >   *    *)  A bugfix for the Page-Down problem
> >   *
> > - *    *)  Formerly when I used Page Down and Page Up, the cursor would be set 
> > + *    *)  Formerly when I used Page Down and Page Up, the cursor would be set
> 
> Space-damage. Don't send trailing-space fixes, or at least add a quick
> note for it at the end of the commit log (eg.: "remove trailing space
> while at it").
Ok, it is right.

Thanks Yann E. MORIN, and All

