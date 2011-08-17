Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab1HQUWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:22:38 -0400
Received: from mail.lang.hm ([64.81.33.126]:58654 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab1HQUWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:22:35 -0400
Date: Wed, 17 Aug 2011 13:20:37 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Jeremiah Foster <jeremiah@jeremiahfoster.com>
cc: Greg KH <greg@kroah.com>, Ben Hutchings <ben@decadent.org.uk>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Subject: Re: [stable] [Stable-review] Future of the -longterm kernel releases
 (i.e. how we pick them).
In-Reply-To: <056B8993-8B70-470A-AFDD-53F587AF3312@jeremiahfoster.com>
Message-ID: <alpine.DEB.2.02.1108171313040.6543@asgard.lang.hm>
References: <20110815041524.GA7578@kroah.com> <1313460542.2981.76.camel@deadeye> <17669FB8-C6FF-4B1F-9765-F1FD991D14CB@jeremiahfoster.com> <20110816223327.GA1534@kroah.com> <056B8993-8B70-470A-AFDD-53F587AF3312@jeremiahfoster.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Aug 2011, Jeremiah Foster wrote:

>> Do they need help from the community
>> instead to help define, implement, and maintain this for them?
>
> I think the answer is yes.
>

to expand on this a bit.

it's a lot easier to look at changelogs and see if a -stable or -longterm 
update is relavent to your systems than it is to watch the flood of 
merges to the latest kerenl and then figure out how to backport them. BUt 
people who start up just compiling their own kernels frequently become 
testers, if not contributers to the kernel. If everyone only runs the 
distro kernels, then the upstream kernel quality will suffer because 
nobody is testing it.

people running -longterm kernels on their productionsystems will not be 
testing the llatest -rc kernel on those systems, but they are likely to be 
more interested in watching and testng new kernel releases (at least on 
lab machines) than people who just wait for things to be backported to the 
distro kernel.

David Lang

