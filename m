Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab0JNUM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 16:12:59 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:43644 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab0JNUM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 16:12:58 -0400
Subject: Re: mmotm 2010-10-13-17-13 uploaded (leds)
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rpurdie@rpsys.net
In-Reply-To: <4CB72C62.1030204@oracle.com>
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org>
	 <20101013212902.2fec6413.randy.dunlap@oracle.com>
	 <1287056312.4641.296.camel@jlt3.sipsolutions.net>
	 <4CB72C62.1030204@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 22:13:37 +0200
Message-ID: <1287087217.4641.442.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-14 at 09:14 -0700, Randy Dunlap wrote:

> > Are there dependencies missing? I was under the impression that this
> > shouldn't be happening. And what's the point in having triggers, but
> > nothing to trigger...? How about the patch below?
> 
> It seems to be due to net/mac80211/Kconfig:
> 
> config MAC80211_LEDS
> 	bool "Enable LED triggers"
> 	depends on MAC80211
> 	select NEW_LEDS
> 	select LEDS_TRIGGERS

Ohh. Indeed, that should be easy to fix, make it depend on
LEDS_TRIGGERS=y || LEDS_TRIGGERS=MAC80211 or so?

> > Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> The patch does not apply cleanly to mmotm, but it seems
> like a good plan...

Hmm, ok, it was against the latest -rc or so. It'll have to wait a bit,
I'm about to leave for a week. Sorry!

johannes

