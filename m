Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab2HBSDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 14:03:32 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934Ab2HBSDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 14:03:31 -0400
Date: Thu, 2 Aug 2012 20:03:26 +0200
From: Richard Weinberger <richard@nod.at>
To: artem.bityutskiy@linux.intel.com
Cc: Tim Bird <tim.bird@am.sony.com>,
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
Message-ID: <20120802200326.37a2d827@spider.haslach.nod.at>
In-Reply-To: <1343930368.25013.215.camel@sauron.fi.intel.com>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
	<1343916747.25013.112.camel@sauron.fi.intel.com>
	<20120802161512.5ac7a303@spider.haslach.nod.at>
	<1343917741.25013.114.camel@sauron.fi.intel.com>
	<20120802165132.1bf1e5d7@spider.haslach.nod.at>
	<1343924267.25013.156.camel@sauron.fi.intel.com>
	<20120802183210.7076aa48@spider.haslach.nod.at>
	<1343925930.25013.163.camel@sauron.fi.intel.com>
	<501AB2C8.9010805@am.sony.com>
	<1343929200.25013.197.camel@sauron.fi.intel.com>
	<20120802194538.26e2ec98@spider.haslach.nod.at>
	<1343930368.25013.215.camel@sauron.fi.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 02 Aug 2012 20:59:28 +0300
schrieb Artem Bityutskiy <artem.bityutskiy@linux.intel.com>:
> > How much PEB should be reserved? 2 x sizeof(fastmap)? 
> 
> Is there any reason why it cannot be the _exact_ maximum number? Not
> more and not less.

The fastmap size is an exact number. 
 
> If I understand correctly, fastmap size is a function of total PEBs
> count. You should be able to calculate the maximum size precisely.

It does.
I was thinking of 2 x sizeof(fastmap) to have reserved PEBs for the
currently used fastmap and PEBs for the new to be installed fastmap.

Thanks,
//richard

