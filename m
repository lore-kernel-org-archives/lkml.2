Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab0IOQGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 12:06:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61169 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab0IOQGs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 12:06:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=MC9+IpXzr1ESC16FQUdi9d5CCjMtUB32vfI/qxorMPZsCkTLPNsQDTSYSKKI/M6wTF
         bIvfOWRiwMqDFOLkizq4Q6iYV9ZqIqJaQ0D20/Au01GL+tCr2B89QvSvLHC6e7RPF8up
         DMYfNSw64+YKs0PNn/Qu3l408rm/jiCRtQloI=
MIME-Version: 1.0
In-Reply-To: <20100915193926.ae2fe838.sfr@canb.auug.org.au>
References: <1284495763-7506-1-git-send-email-arnd@arndb.de> <20100915193926.ae2fe838.sfr@canb.auug.org.au>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 15 Sep 2010 09:06:25 -0700
Message-ID: <AANLkTimCsuTXM3e0D8zPEsugd2W9c7ziTK+Xx2wmkJb0@mail.gmail.com>
Subject: Re: [PATCH 00/15] change default_llseek action
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, Jeremy Kerr <jk@ozlabs.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Julia Lawall <julia@diku.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-omap@vger.kernel.org,
        linuxppc-dev@ozlabs.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Samuel Ortiz <samuel@sortiz.org>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 2:39 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Arnd,
>
> On Tue, 14 Sep 2010 22:22:28 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> Stephen, please add
>> git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git llseek
>
> Added from today.
>
> Thanks for adding your subsystem tree as a participant of linux-next.  As
> you may know, this is not a judgment of your code.  The purpose of
> linux-next is for integration testing and to lower the impact of
> conflicts between subsystems in the next merge window.
>
> You will need to ensure that the patches/commits in your tree/series have
> been:
>     * submitted under GPL v2 (or later) and include the Contributor's
>        Signed-off-by,

I should note this should say the code should be GPL-compatible, it
doesn't need to be GPLv2 (or later). Furthermore the contributors of
the subsystem respect the individual licenses of the files through the
Developers Certificate of Origin, which tells the developers what the
meaning of Signed-off-by means.

  Luis
