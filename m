Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab0E0JN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 05:13:26 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:4467 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933166Ab0E0JNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 05:13:15 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o4R8HErQ018669
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Pavel Machek <pavel@ucw.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Arve Hj?nnev?g <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       tytso@mit.edu
In-Reply-To: <1274898180.4467.925.camel@mulgrave.site>
References: <1274863342.5882.4850.camel@twins>
	 <20100526112303.3fef15a4@schatten.dmk.lab>
	 <1274866402.5882.5051.camel@twins>
	 <AANLkTil9ZtMFxTfE6ITiFNOl4S1k3Lvdp5BPgGX7LJhw@mail.gmail.com>
	 <1274868384.5882.5169.camel@twins>
	 <AANLkTimHGpRAZklIwXu6wEbA3coKXJvCVLxj2twerkCw@mail.gmail.com>
	 <1274869262.5882.5222.camel@twins>
	 <AANLkTik9LINPmabJfVi0jfVs5sjVS_1l00WpnVTFEuLV@mail.gmail.com>
	 <1274890736.4467.574.camel@mulgrave.site>
	 <1274891308.1674.1766.camel@laptop>  <20100526165919.GB2089@elf.ucw.cz>
	 <1274893309.1674.1773.camel@laptop>
	 <1274894685.4467.758.camel@mulgrave.site>
	 <alpine.LFD.2.00.1005261948290.2995@localhost.localdomain>
	 <1274898180.4467.925.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 10:17:14 +0200
Message-ID: <1274948234.14002.27.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-wuwien-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2010-05-26 at 13:23 -0500, James Bottomley wrote:
> On Wed, 2010-05-26 at 19:51 +0200, Thomas Gleixner wrote:
[...]
> > Darn, _we_ have to deal with that forever as it sets a crappy user
> > space ABI in stone.
> 
> I really don't see how it is ... the ABI comes with a switch that allows
> it to be disabled, so only platforms wishing to use it have to support
> it.  Even on those platforms that do support it, we can translate most

You completely missed the point: The crappy user interface - and
interferences with pother subsystems - must be maintained for ages - and
that is independent if one uses it or not. Even worse if it's not widely
used.

> of it into pm QoS stuff and if one day someone solves the rogue app
> problem, we can migrate over.

If it's so important for Android and no one else, Android can carry it
out of tree.

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

