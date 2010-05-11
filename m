Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab0EKVgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 17:36:45 -0400
Received: from kroah.org ([198.145.64.141]:48441 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879Ab0EKVgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 17:36:41 -0400
Date: Tue, 11 May 2010 14:36:04 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Ken Werner <ken.werner@web.de>, Andi Kleen <andi@firstfloor.org>,
       stable@kernel.org
Subject: Re: [stable] cpumask: fix compat getaffinity
Message-ID: <20100511213604.GA27050@kroah.com>
References: <20100511104334.E572.A69D9226@jp.fujitsu.com>
 <20100511151526.E578.A69D9226@jp.fujitsu.com>
 <20100511152002.GB16561@kroah.com>
 <201005112013.56392.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005112013.56392.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 08:13:55PM +0200, Arnd Bergmann wrote:
> On Tuesday 11 May 2010 17:20:02 Greg KH wrote:
> > > AFAIK, -stable is mainly used for distro and they have many and many
> > > packages. we can't assume no app read /sys files directly.
> > > IOW, To change /sys printing format is a bit risky change. frequently
> > > compatibility breaking natually break code stability.
> > 
> > Ah, the sysfs user/kernel API is what you are referring to here, right?
> > If so, remember, any changes need to be documented in Documentation/API
> > :)
> > And as for distros using -stable for their releases, that's fine, they
> > well know the risks/benefits for that and handle changes on their own.
> 
> Would it make sense to use my initial patch for -stable, which reverts
> the ABI back to before the change that caused the problem, but apply
> the correct fix (changing the ABI throughout) for future releases?

I do not know, as I really don't know what the issue is here.

I trust that you, and the others, can come up with a fix for mainline
properly, and if it applies to the stable tree, feel free to forward it
to stable@kernel.org for submission then.

thanks,

greg k-h
