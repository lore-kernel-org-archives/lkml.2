Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab2CIIpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 03:45:15 -0500
Received: from 1wt.eu ([62.212.114.60]:62989 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab2CIIpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 03:45:13 -0500
Date: Fri, 9 Mar 2012 09:41:35 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Tony Luck <tony.luck@intel.com>, Jiri Slaby <jirislaby@gmail.com>,
        raven@themaw.net
Subject: Re: Build broken on s390 and ia64 [was: Linux 2.6.32.58]
Message-ID: <20120309084135.GF25153@1wt.eu>
References: <20120304180911.GA7336@kroah.com> <4F54A46A.6000305@suse.cz> <20120305120241.GA3627@osiris.boeblingen.de.ibm.com> <4F54B618.1090301@suse.cz> <20120305223338.GE2930@1wt.eu> <1331270953.3022.89.camel@deadeye> <20120309065703.GE25153@1wt.eu> <4F59BE04.5030509@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F59BE04.5030509@suse.cz>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 09:23:32AM +0100, Jiri Slaby wrote:
> On 03/09/2012 07:57 AM, Willy Tarreau wrote:
> > Thanks but now I have a doubt, maybe Jiri and Tony can help. In the
> > commit above, Tony says that CONFIG_COMPAT has been broken for a long
> > time (2008) and nobody apparently uses it. Still, Jiri got a build
> > failure because he used CONFIG_COMPAT. So either there are some valid
> > uses and we should not remove the feature that late in a stable branch,
> > or Jiri only encountered it upon a make allyesconfig then it might
> > be safe to remove it.
> 
> It's a SLE11-SP1 that is using the kernel and has COMPAT on ia64
> enabled. I don't know if it is broken or if we provide support for that.

Thanks for the quick feedback Jiri.

> If you are sure COMPAT is broken on ia64 even in 2.6.32, feel free to
> ban COMPAT completely.

Just checked on the net, it looks like Tony's comment is right as
SLE11 apparently provides ia32el.

So that's OK, I'll apply Ben's patch.

Thanks guys,
Willy

