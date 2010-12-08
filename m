Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab0LHF0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 00:26:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008Ab0LHF0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 00:26:43 -0500
Date: Tue, 7 Dec 2010 20:16:56 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        "David S. Miller" <davem@davemloft.net>, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Robin Holt <holt@sgi.com>, Willy Tarreau <w@1wt.eu>,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Vlad Yasevich <vladislav.yasevich@hp.com>,
        Sridhar Samudrala <sri@us.ibm.com>
Subject: Re: [34/44] Limit sysctl_tcp_mem and sysctl_udp_mem initializers
 to prevent integer overflows.
Message-ID: <20101208041656.GA2291@suse.de>
References: <20101208003205.GA4286@kroah.com>
 <20101208000642.975564500@clark.site>
 <AANLkTimTw3O-OM-5Cgv0ELNj8SmMjaaeMHMd2NNezxi7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimTw3O-OM-5Cgv0ELNj8SmMjaaeMHMd2NNezxi7@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 05:22:34PM -0800, Linus Torvalds wrote:
> On Tue, Dec 7, 2010 at 4:04 PM, Greg KH <gregkh@suse.de> wrote:
> >
> > From: Robin Holt <holt@sgi.com>
> >
> > [ Problem was fixed differently upstream. -DaveM ]
> 
> Gaah. I'd really like to see more of a description for things like
> this. A commit ID for the alternate fix, or at least a few words about
> the different fix or reason why upstream doesn't need the stable
> commit.

I'll let David confirm this, he's the one who sent it to me :)

thanks,

greg k-h
