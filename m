Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab0ITSLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:11:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51330 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab0ITSLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:11:06 -0400
Date: Mon, 20 Sep 2010 20:11:00 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
Cc: Alan Ott <alan@signal11.us>, Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [BUG] object: is not initialized, yet kobject_put() is being
 called
Message-ID: <20100920181100.GA12295@fancy-poultry.org>
References: <20100812091659.GA1591@arch.tripp.de>
 <alpine.LNX.2.00.1008121148100.2702@pobox.suse.cz>
 <20100812113624.GB1591@arch.tripp.de>
 <20100812114513.GA1584@arch.tripp.de>
 <20100812115657.GA1611@arch.tripp.de>
 <alpine.LNX.2.00.1008121401580.2702@pobox.suse.cz>
 <alpine.LNX.2.00.1008121457060.2702@pobox.suse.cz>
 <20100812130411.GA1626@arch.tripp.de>
 <4C63F285.8070801@signal11.us>
 <20100812164035.GB6761@fritha.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100812164035.GB6761@fritha.org>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100810 (GNU/Linux)
X-Provags-ID: V02:K0:/YMQRzN8MVdOpwQ3Vjrr6Yh8k7ZfRBNYPZgpvOuGJNi
 7YpB9ksjJY+rTIkLksNKHdgHlWZrZU0yRNniLYoXJWZhqxdtgW
 h0ueFd6bKE93FVfIqePRXYvAh+zs+ASz2QKaw1kkldcRQ5uc2/
 tYCR//SMU6IfpJbdN4kxD3UjxdmQQYQb45yru7ahtiqBxW2m6z
 6gB4dc0P/4Cby521Vo3nA==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.08.2010, Heinz Diehl wrote: 

> > >>Could please those of you, who are able to reproduce the problem, verify
> > >>whether the patch below (completely untested) makes everything behave
> > >>again? Thanks.
 
> > >Yes, everything behaves again. Thanks Jiri.
  
> > Seconded. Works good. Thanks for your support Jiri.
 
> Thirded! This fixes the warning here.

Unfortunately, I have to take up this problem a second time. 
I considered the issue fixed, and in fact it was using Jiris patch.

However, the same problem came back while testing 2.6.36-rc4 and the
following -git's. /var/log/warn shows the same warning as mentioned in
the first mail in this thread:

 Sep 20 08:18:42 liesel apcupsd[5436]: apcupsd FATAL ERROR in linux-usb.c at line 609 
 Cannot find UPS device -- For a link to detailed USB trouble
 shooting information, please see <http://www.apcupsd.com/support.html>.
 Sep 20 08:18:42 liesel apcupsd[5436]: apcupsd error shutdown completed

No additional oops this time, only the warning, and my UPS is no longer
working.

Jiris patch obviously didn't made it into 2.6.36-rc4, and it doesn't
apply nay longer either.

Thanks,
Heinz.
