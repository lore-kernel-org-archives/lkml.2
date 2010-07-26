Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab0GZWSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:18:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755595Ab0GZWSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:18:00 -0400
Date: Mon, 26 Jul 2010 15:17:49 -0700
From: Greg KH <gregkh@suse.de>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Paul Menage <menage@google.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
Message-ID: <20100726221749.GB10102@suse.de>
References: <20100722182638.GA12712@kroah.com>
 <AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
 <20100722183614.GA5443@suse.de>
 <AANLkTinsd2gWOHb3w9gzvKO5vdwLBT7DZOY+2xCUz_5_@mail.gmail.com>
 <AANLkTimm9XGvK2H55V7N76JPU05iHk_dY5JjOLifQTsr@mail.gmail.com>
 <AANLkTi=OMaKuk+ReeqCfBGes76BjKYyUdqxPOQfH8EcZ@mail.gmail.com>
 <20100726212858.GA15904@suse.de>
 <AANLkTimmAfhw7WhPHHU6d4izkzvp2oxOSzNN8JjNu_nU@mail.gmail.com>
 <20100726220546.GB9671@suse.de>
 <AANLkTi=d1-Uf4TeyvMH3evo91zPWjbincij=HC0ny0Ym@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=d1-Uf4TeyvMH3evo91zPWjbincij=HC0ny0Ym@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 12:08:03AM +0200, Dhaval Giani wrote:
> On Tue, Jul 27, 2010 at 12:05 AM, Greg KH <gregkh@suse.de> wrote:
> > On Mon, Jul 26, 2010 at 02:55:18PM -0700, Paul Menage wrote:
> >> On Mon, Jul 26, 2010 at 2:28 PM, Greg KH <gregkh@suse.de> wrote:
> >> >
> >> > Ok, again, after all of this, who is going to be applying this patch to
> >> > their tree for the .36 merge window?
> >>
> >> There's no specific cgroups tree - cgroups patches generally go via akpm.
> >>
> >> >
> >> > Or should I apply it to my driver-core one?
> >> >
> >>
> >> That sounds like an OK option too.
> >
> > Wonderful, can I get some acks from the cgroups maintainers?  I'll
> > gladly take it through my tree.
> >
> 
> while I am not a maintainer, from the libcgroup side at least,
> 
> Acked-by: Dhaval Giani <dhaval.giani@gmail.com>

Thanks, I've added this to the patch.

greg k-h
