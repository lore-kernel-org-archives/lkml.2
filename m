Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab0KVBMc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:12:32 -0500
Received: from kroah.org ([198.145.64.141]:56560 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756353Ab0KVBMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:12:30 -0500
Date: Sun, 21 Nov 2010 17:00:38 -0800
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: G??bor Stefanik <netrolller.3d@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
        Charles Marker <Charles.Marker@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Kevin Hayes <kevin@atheros.com>, Zhifeng Cai <zhifeng.cai@atheros.com>,
        Don Breslin <Don.Breslin@atheros.com>,
        Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
Subject: Re: Challenges with doing hardware bring up with Linux first
Message-ID: <20101122010038.GA7688@kroah.com>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com> <F46C52ED-8DB8-4347-957D-B9D84406D53F@mit.edu> <AANLkTinyafwe9MyXhSSe5vxEKnTUeLV0AZDWY_uXsu8f@mail.gmail.com> <20101121130236.GE23423@thunk.org> <20101121172906.GD3703@kroah.com> <AANLkTik6MQjYTCQ4wtyRpOGb94uyUTA+juvX-8UsP95J@mail.gmail.com> <20101121203124.1ba8212e@lxorguk.ukuu.org.uk> <20101121214407.GH23423@thunk.org> <AANLkTinEm1mLAtPZdEp2sHRfKPeV6qYP8f9Dbbr92_JD@mail.gmail.com> <AANLkTikVdm5bnXhGeg9rYsacWJsf_2s6A+b3iKJQeisD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikVdm5bnXhGeg9rYsacWJsf_2s6A+b3iKJQeisD@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 01:50:30PM -0800, Luis R. Rodriguez wrote:
> > By forcing the driver to be GPL, you automatically exclude Windows
> > from the list of platforms supported by such a cross-OS driver, as the
> > Windows NDIS headers are AFAIK under a GPL-incompatible license, so no
> > GPL driver can be written for Windows.
> 
> I've actually have been told GPL drivers for windows are possible with
> some hard work. I have yet to investigate further on what that "hard
> work" means. But yes, that is a good example.

The "hard work" means you can not use the Windows DDK at all.  People
have worked to reimplement the header files needed for this into mingw,
but it really restricts you and forces you to write "native" drivers for
Windows, not being able to take advantage of their driver model code at
all.

Oracle did a bunch of work for this in the past to port some of their
Linux kernel work to Windows, ask Andy Grover if you have questions
about it.

hope this helps,

greg k-h
