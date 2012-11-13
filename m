Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab2KMWdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:33:43 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:41951 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab2KMWdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:33:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: frank.rowand@am.sony.com
Cc: Randy Dunlap <rdunlap@infradead.org>, Thiago Farina <tfransosi@gmail.com>,
        linux list <linux-kernel@vger.kernel.org>
Subject: Re: acked-by meaning
Date: Tue, 13 Nov 2012 23:38:01 +0100
Message-ID: <2562599.USXBfge9I9@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <50A2C5C3.8040804@am.sony.com>
References: <CACnwZYc4xY5r_oxu36URsSHen1kHDiStULMyB2LrZB+Eg=FF2g@mail.gmail.com> <50A07169.6090201@infradead.org> <50A2C5C3.8040804@am.sony.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 13, 2012 02:12:19 PM Frank Rowand wrote:
> On 11/11/12 19:47, Randy Dunlap wrote:
> > On 11/11/2012 05:40 PM, Thiago Farina wrote:
> > 
> >> Hi,
> >>
> >> What is the meaning of 'Acked-by:' line? Is the same of LGTM? How it
> >> differs from 'Reviewed-by:'?
> > 
> 
> > Reviewed-by: is stronger than Acked-by:.
> > If someone replies with Reviewed-by, they also accept some
> > responsibility for fixing any problems that the patch might
> > introduce after it is merged.
> 
> I haven't found a "responsibility for fixing any problems" in the
> references provided below.  Can you help me out by pointing
> to a specific sentence or another reference?

"Reviewed-by" informs the maintainer of the relevant subsystem that the
reviewer has spent time to go through the patch and understand what it
does in detail.  It also implies that the reviewer has no objections against
the patch.

The maintainer can use this information when deciding whether or not to
apply the patch, possibly without spending as much time on it as would be
necessary otherwise.

> > Acked-by just means agreement with the patch.

Actually, the meaning of "Acked-by" depends on who gives it.

If the patch touches multiple subsystems and their maintainers "ack" it,
they inform each other that they have no objections against it and, from their
perspective, it can be merged if any one of them wants to take it.  So in that
particular case it's rather strong.

On the other hand, if the "ack" is given by someone who's not a maintainer,
the meaning of it is pretty much the same as for a "like" on Facebook. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
