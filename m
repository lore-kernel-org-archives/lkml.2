Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab0EZWJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:09:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44745 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab0EZWJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:09:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Florian Mickler <florian@mickler.org>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
Date: Thu, 27 May 2010 00:10:41 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, James Bottomley <James.Bottomley@suse.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Arve Hj?nnev?g" <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
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
References: <AANLkTil9ZtMFxTfE6ITiFNOl4S1k3Lvdp5BPgGX7LJhw@mail.gmail.com> <20100526172824.GA9069@elf.ucw.cz> <20100526211542.1bfa2564@schatten.dmk.lab>
In-Reply-To: <20100526211542.1bfa2564@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005270010.41111.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 May 2010, Florian Mickler wrote:
> On Wed, 26 May 2010 19:28:24 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> 
> > Besides that it is not linux system at all?
> 
> I believe the kernel to be a layer between userspace and hardware. What
> business is it to the kernel if it runs whatever android
> uses as init process or /bin/bash, sys-v-init or systemd?
> 
> There is this thing called choice. 
> 
> > 
> > Yes, with custom userspace it works extremely nicely.
> > 
> > Had anyone even tried running oportunistic suspend on normal desktop?
> > 									Pavel
> 
> I don't think this is a valid concern. Just because current linux/gnu
> systems don't implement the userspace part of this interface doesn't
> mean it is useless or broken. 

Agreed.

BTW, this is a valid point.  We are used to think about Linux as the kernel
plus the GNU user space, but that's not how it has to be.

Thanks,
Rafael
