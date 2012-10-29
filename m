Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab2J2KLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 06:11:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58266 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758041Ab2J2KLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 06:11:23 -0400
Date: Mon, 29 Oct 2012 11:11:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add some drop_caches documentation and info messsge
Message-ID: <20121029101120.GC4326@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jiri Kosina <jkosina@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Dave Hansen <dave@linux.vnet.ibm.com>,
	Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20121012125708.GJ10110@dhcp22.suse.cz>
 <20121024210600.GA17037@liondog.tnic>
 <20121024141303.0797d6a1.akpm@linux-foundation.org>
 <1787395.7AzIesGUbB@vostro.rjw.lan>
 <20121024181752.de011615.akpm@linux-foundation.org>
 <alpine.LRH.2.00.1210290958450.10392@twin.jikos.cz>
 <20121029095819.GA4326@liondog.tnic>
 <alpine.LNX.2.00.1210291100470.19184@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1210291100470.19184@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 11:01:59AM +0100, Jiri Kosina wrote:
> Well if the point of dropping caches is lowering the resume time, then
> the point is rendered moot as soon as you switch to your browser and
> have to wait noticeable amount of time until it starts reacting.

Not the resume time - the suspend time. If, say, one has 8Gb of memory
and Linux nicely spreads all over it in caches, you don't want to wait
too long for the suspend image creation.

And nowadays, since you can have 8Gb in a laptop, you really want to
keep that image minimal so that suspend-to-disk is quick.

The penalty of faulting everything back in is a cost we'd be willing to
pay, I guess.

Thanks.

-- 
Regards/Gruss,
    Boris.
