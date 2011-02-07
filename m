Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1BGNJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 08:09:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45991 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751200Ab1BGNJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 08:09:54 -0500
Date: Mon, 7 Feb 2011 13:09:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org
Subject: Re: [PATCH] PM: Hide CONFIG_PM from users
Message-ID: <20110207130951.GF10564@opensource.wolfsonmicro.com>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110207124846.GA10442@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110207124846.GA10442@elte.hu>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 01:48:46PM +0100, Ingo Molnar wrote:
> * Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > Since having the configuration option requires non-zero effort to
> > maintain, with ifdefery in most drivers, but it is used with vanishing
> > rarity it is simpler to just remove the option.

> Well, either make it dependent on CONFIG_EXPERT or remove the option altogether.

The goal is the latter but when I saw the IA64 emulator there I didn't
want to make it instabuggy.  The current patch means we get the UI
effect of the change (especially in terms of avoiding it turning up in
randconfigs or whatever).
