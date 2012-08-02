Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab2HBRGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 13:06:23 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab2HBRGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 13:06:22 -0400
Date: Thu, 2 Aug 2012 19:06:17 +0200
From: Richard Weinberger <richard@nod.at>
To: Tim Bird <tim.bird@am.sony.com>
Cc: "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "Heinz.Egger@linutronix.de" <Heinz.Egger@linutronix.de>,
        "thomas.wucher@linutronix.de" <thomas.wucher@linutronix.de>,
        "shmulik.ladkani@gmail.com" <shmulik.ladkani@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Marius.Mazarel@ugal.ro" <Marius.Mazarel@ugal.ro>,
        "nyoushchenko@mvista.com" <nyoushchenko@mvista.com>
Subject: Re: UBI fastmap updates
Message-ID: <20120802190617.7182924f@spider.haslach.nod.at>
In-Reply-To: <501AB2C8.9010805@am.sony.com>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
	<1343916747.25013.112.camel@sauron.fi.intel.com>
	<20120802161512.5ac7a303@spider.haslach.nod.at>
	<1343917741.25013.114.camel@sauron.fi.intel.com>
	<20120802165132.1bf1e5d7@spider.haslach.nod.at>
	<1343924267.25013.156.camel@sauron.fi.intel.com>
	<20120802183210.7076aa48@spider.haslach.nod.at>
	<1343925930.25013.163.camel@sauron.fi.intel.com>
	<501AB2C8.9010805@am.sony.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 2 Aug 2012 10:03:04 -0700
schrieb Tim Bird <tim.bird@am.sony.com>:
> >> If everything goes wrong, fastmap makes sure that no fastmap is on
> >> flash.
> >> In case of a powercut we fall back to scanning mode.
> >> R/O mode is overkill IMHO.
> > 
> > So can I interpret this the following way. Not only fastmap give no
> > guarantees that it exists after an unclean reboot, it does not even
> > give guarantees that it exists after a clean reboot.
> > 
> > Unless I am confused, the fastmap design is over-simplified.
> 
> Fastmap is an optimization.  Maybe I'm missing something, but
> I'm not sure why, if the optimization stopped working, you
> would want to reduce the functionality of the file system.

That's *exactly* my point.
If fastmap is available - fine, we have fast boot - yay!
But if something really nasty happens we can safely fall back
to scanning mode.
And fastmap is designed to allow this.

Thanks,
//richard
