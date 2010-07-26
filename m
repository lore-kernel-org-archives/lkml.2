Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0GZWGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:06:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470Ab0GZWGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:06:47 -0400
Date: Mon, 26 Jul 2010 15:05:46 -0700
From: Greg KH <gregkh@suse.de>
To: Paul Menage <menage@google.com>
Cc: Dhaval Giani <dhaval.giani@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
Message-ID: <20100726220546.GB9671@suse.de>
References: <20100722182638.GA12712@kroah.com>
 <AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
 <20100722183614.GA5443@suse.de>
 <AANLkTinsd2gWOHb3w9gzvKO5vdwLBT7DZOY+2xCUz_5_@mail.gmail.com>
 <AANLkTimm9XGvK2H55V7N76JPU05iHk_dY5JjOLifQTsr@mail.gmail.com>
 <AANLkTi=OMaKuk+ReeqCfBGes76BjKYyUdqxPOQfH8EcZ@mail.gmail.com>
 <20100726212858.GA15904@suse.de>
 <AANLkTimmAfhw7WhPHHU6d4izkzvp2oxOSzNN8JjNu_nU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimmAfhw7WhPHHU6d4izkzvp2oxOSzNN8JjNu_nU@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 02:55:18PM -0700, Paul Menage wrote:
> On Mon, Jul 26, 2010 at 2:28 PM, Greg KH <gregkh@suse.de> wrote:
> >
> > Ok, again, after all of this, who is going to be applying this patch to
> > their tree for the .36 merge window?
> 
> There's no specific cgroups tree - cgroups patches generally go via akpm.
> 
> >
> > Or should I apply it to my driver-core one?
> >
> 
> That sounds like an OK option too.

Wonderful, can I get some acks from the cgroups maintainers?  I'll
gladly take it through my tree.

thanks,

greg k-h
