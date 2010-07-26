Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab0GZWR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:17:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699Ab0GZWR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:17:57 -0400
Date: Mon, 26 Jul 2010 15:17:41 -0700
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
Message-ID: <20100726221741.GA10102@suse.de>
References: <20100722182638.GA12712@kroah.com>
 <AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
 <20100722183614.GA5443@suse.de>
 <AANLkTinsd2gWOHb3w9gzvKO5vdwLBT7DZOY+2xCUz_5_@mail.gmail.com>
 <AANLkTimm9XGvK2H55V7N76JPU05iHk_dY5JjOLifQTsr@mail.gmail.com>
 <AANLkTi=OMaKuk+ReeqCfBGes76BjKYyUdqxPOQfH8EcZ@mail.gmail.com>
 <20100726212858.GA15904@suse.de>
 <AANLkTimmAfhw7WhPHHU6d4izkzvp2oxOSzNN8JjNu_nU@mail.gmail.com>
 <20100726220546.GB9671@suse.de>
 <AANLkTi=Vrax+ob87uiDzeMxOmuDNYUWnDKG0jpfQppAp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=Vrax+ob87uiDzeMxOmuDNYUWnDKG0jpfQppAp@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 03:09:09PM -0700, Paul Menage wrote:
> On Mon, Jul 26, 2010 at 3:05 PM, Greg KH <gregkh@suse.de> wrote:
> >
> > Wonderful, can I get some acks from the cgroups maintainers?  I'll
> > gladly take it through my tree.
> 
> Sure.
> 
> Acked-by: Paul Menage <menage@google.com>

Wonderful, now queued up.

greg k-h
