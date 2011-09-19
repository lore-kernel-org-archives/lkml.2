Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab1ISPO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 11:14:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58719 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab1ISPO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 11:14:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] misc: remove CONFIG_MISC_DEVICES
Date: Mon, 19 Sep 2011 17:14:18 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Randy Dunlap <rdunlap@xenotime.net>, Jean Delvare <khali@linux-fr.org>,
        Luciano Coelho <coelho@ti.com>, matti.j.aaltonen@nokia.com,
        johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, mchehab@infradead.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
References: <20110829102732.03f0f05d.rdunlap@xenotime.net> <2282172.TF7nejTDIZ@wuerfel> <20110919130755.GA9829@kroah.com>
In-Reply-To: <20110919130755.GA9829@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109191714.18334.arnd@arndb.de>
X-Provags-ID: V02:K0:0/trgz6W5JaqH/I0NMLZ5cID1/+wvDNPcuvO3i+TB6N
 y14qdlLGqXNKrhKWTbgaWlWEl04QFseBLbxEWZcr3XyYXj0gIf
 DrBMOutQWteDKS8ZjML8ecHUBFJatine8qrsw0Amvy3b9I/RP7
 yGU/4j0U/+TToplTiQvVQjtFy0ZvriChxjlDmCcPzVyhXg9+8P
 z3nraNrHU7M1zhtDCVjs7GjC54rm1izl5jBrZCqnUDiawDSh1Z
 95DspSFKp0p4OhdnArX7qfy5WnoZuBNvrjYKMpngBqbiT8M8KU
 +2HBFAcwKqfNBFa+GQCSxIeO9puazaWZDDrqsyhrh5O+ioPjnq
 7dSGTaQ0CbUjdyZQ+FqU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 September 2011, Greg KH wrote:
> That sounds good to me, I'll be glad to collect the patches and push
> them to Linus for both of those trees (might as well keep them in the
> same git tree, no need to separate them, right?) and I'll rely on you
> for review and acking them.  Much like I do today for the tty and serial
> trees.
> 
> I'll go set up the trees locally today and when kernel.org opens back
> up, make them public and add them to linux-next.

Ok, great!

Thanks,

	Arnd
