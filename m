Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab0EZQ73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:59:29 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:52600 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754797Ab0EZQ71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:59:27 -0400
Date: Wed, 26 May 2010 18:59:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: James Bottomley <James.Bottomley@suse.de>,
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
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
Message-ID: <20100526165919.GB2089@elf.ucw.cz>
References: <1274863342.5882.4850.camel@twins>
 <20100526112303.3fef15a4@schatten.dmk.lab>
 <1274866402.5882.5051.camel@twins>
 <AANLkTil9ZtMFxTfE6ITiFNOl4S1k3Lvdp5BPgGX7LJhw@mail.gmail.com>
 <1274868384.5882.5169.camel@twins>
 <AANLkTimHGpRAZklIwXu6wEbA3coKXJvCVLxj2twerkCw@mail.gmail.com>
 <1274869262.5882.5222.camel@twins>
 <AANLkTik9LINPmabJfVi0jfVs5sjVS_1l00WpnVTFEuLV@mail.gmail.com>
 <1274890736.4467.574.camel@mulgrave.site>
 <1274891308.1674.1766.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274891308.1674.1766.camel@laptop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2010-05-26 18:28:28, Peter Zijlstra wrote:
> On Wed, 2010-05-26 at 11:18 -0500, James Bottomley wrote:
> > > Or make the suspend manager a C proglet and provide a JNI interface,
> > > or whatever.
> > 
> > It's a fairly large piece of code to try to rewrite in C, so I don't
> > think that's feasible on a reasonable timescale.  Android does have the
> > concept of special sockets that can be used to communicate from less to
> > more privileged processes (it has a very segmented runtime model), so
> > these might be usable ... they have a drawback that they're essentially
> > named pipes, so no multiplexing, but one per suspend influencing C
> > process shouldn't be a huge burden. 
> 
> It wouldn't need to convert the whole Frameworks layer into C, just
> enough to manage the suspend state.
> 
> Anyway, I think there's been enough arguments against even the concept
> of opportunistic/auto-suspend, and I for one will object with a NAK if
> Rafael send this to Linus.

It was submitted already. I tried to followup with NAK, but can't
currently see it in the archive.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
