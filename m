Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab2BULD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 06:03:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51360 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab2BULDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 06:03:55 -0500
Date: Tue, 21 Feb 2012 12:03:53 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Chris Bagwell <chris@cnpbagwell.com>
Cc: Przemo Firszt <przemo@firszt.eu>, pinglinux@gmail.com,
        peter.hutterer@who-t.net, linuxwacom-devel@lists.sourceforge.net,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: wacom: Force new name for Wacom Intuos4 WL
 PTK-540WL
In-Reply-To: <CAGzDe_ZAni9Jtu4RrwmuRSOPFGxFz93JWw_VhzwieT2JJ-K8Hw@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1202211203270.31150@pobox.suse.cz>
References: <1329500830-16767-1-git-send-email-przemo@firszt.eu> <CAGzDe_ZAni9Jtu4RrwmuRSOPFGxFz93JWw_VhzwieT2JJ-K8Hw@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Feb 2012, Chris Bagwell wrote:

> On Fri, Feb 17, 2012 at 11:47 AM, Przemo Firszt <przemo@firszt.eu> wrote:
> > The name reported by Inutos4 WL connected by bluetooth is "PTK-540WL" and
> > to make it consistent with other Wacom devices it has to be converted to
> > "Wacom Intuos4 WL". It also makes userland applications aware that it's
> > a Wacom device.
> >
> > Signed-off-by: Przemo Firszt <przemo@firszt.eu>
> > ---
> 
> Its worth noting this aligns naming of device to same used when this
> device is plugged into USB port and controlled by USB wacom driver;
> and thus helps align userland logic to route to apps like
> xf86-input-wacom.
> 
> Reviewed-by: Chris Bagwell <chris@cnpbagwell.com>

I have updated changelog to include the comment from Chris and applied, 
thanks everybody.

-- 
Jiri Kosina
SUSE Labs
