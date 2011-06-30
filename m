Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1F3WyC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:54:02 -0400
Received: from webbox4.loswebos.de ([213.187.93.205]:55771 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab1F3WyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:54:00 -0400
Date: Fri, 1 Jul 2011 00:53:52 +0200
From: Marc Koschewski <marc@osknowledge.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [REGRESSION] suspend/resume broken on T510
Message-ID: <20110630225351.GA17981@marc.osknowledge.org>
References: <20110630220050.GB30291@marc.osknowledge.org>
 <201107010007.27588.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107010007.27588.rjw@sisk.pl>
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E 38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.kosik.org/pubkey.asc
X-Blog: http://www.kosik.org/blog/
X-Operating-System: Linux marc 2.6.39-dezzy
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki <rjw@sisk.pl> [2011-07-01 00:07:27 +0200]:

Hi,

here's the bug: https://bugzilla.kernel.org/show_bug.cgi?id=38582

> Hi,
> 
> On Friday, July 01, 2011, Marc Koschewski wrote:
> > Hi guys,
> > 
> > I just thought to wait some what longer than -rc3 to report: suspend/resume is
> > broken in the current git. I blacklisted the 'mei' module so the suspend worked
> > as of rc4 (last 'first tested and working' version) with knowledge of the
> > mei-bug.
> > 
> > However, my system does not resume anymore on my T510. After suspend the 'moon'
> > turns on as usual on 3.0.0-git and the box sleeps. After opening the lid it somehow
> > wakes up but doesn't boot/resume. It just stalls after some HDD activity.
> > 
> > If have no idea what it could be - and I unfortunately cannot bisect it down to
> > anything > 2.6.39. I left out rc1 and rc2 this time due to having no time to
> > experiment this month. However, my .config is attached if anyone needs it...
> 
> Well, perhaps let us know the hardware configuration (attach dmesg?).
> 
> Anyway, I'm not sure if there's anyone who can figure out what _may_ be wrong
> on the basis of your description alone.  It would be good if you could file
> a bug in http://bugzilla.kernel.org and let me know its number.
> 
> Thanks,
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
Marc Koschewski
