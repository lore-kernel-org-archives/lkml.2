Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880Ab0J2Izg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 04:55:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33253 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755963Ab0J2Izc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 04:55:32 -0400
Date: Fri, 29 Oct 2010 10:55:30 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Tom Vier <tom@triadsys.com>, Samuel Thibault <sthibault@debian.org>,
        594089@bugs.debian.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Bug#594089: keyboard-configuration: caps lock keycode problem
In-Reply-To: <20101027091029.GB28895@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.00.1010291054410.6879@pobox.suse.cz>
References: <20100903235540.GA9149@const> <4C866913.3030201@triadsys.com> <4C8E6861.1070502@triadsys.com> <20101024144150.GV24091@const.famille.thibault.fr> <20101025045003.GA1438@core.coreip.homeip.net> <4CC58816.3090301@triadsys.com>
 <20101025180320.GA4725@const.famille.thibault.fr> <4CC6E9D8.8010201@triadsys.com> <20101026161820.GE13097@core.coreip.homeip.net> <4CC7426C.8040502@triadsys.com> <20101027091029.GB28895@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010, Dmitry Torokhov wrote:

> First of all, the device appears to use duplicate usages for
> CapsLock/Favorites and RightShift/Previous so we better set up the
> duplicate usages quirk. I wonder how the other OS copes with diferent
> keys using the same usages. Jiri, any ideas?

That thing I have been also wondering about when introducing the quirk for 
duplicate usages, but I haven't really found out. It's a bit odd.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
