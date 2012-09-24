Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab2IXWb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 18:31:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59212 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2IXWb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 18:31:57 -0400
Date: Mon, 24 Sep 2012 19:31:49 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2012-09-18
Message-ID: <20120924223149.GB7922@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20120919013113.GG24689@joana>
 <CAB=NE6XKNSMeS3_uzcGsGBhcm6ZKtJwJ=DdAq_DoWmKTXQvV=Q@mail.gmail.com>
 <20120924184622.GA7922@joana>
 <20120924195422.GF32351@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924195422.GF32351@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* John W. Linville <linville@tuxdriver.com> [2012-09-24 15:54:22 -0400]:

> On Mon, Sep 24, 2012 at 03:46:22PM -0300, Gustavo Padovan wrote:
> > * Luis R. Rodriguez <mcgrof@do-not-panic.com> [2012-09-21 18:06:42 -0700]:
> > 
> > > On Tue, Sep 18, 2012 at 6:31 PM, Gustavo Padovan <gustavo@padovan.org> wrote:
> > > 
> > > > Johan Hedberg (2):
> > > >       Bluetooth: mgmt: Implement support for passkey notification
> > > 
> > > Too late now... but why did we allow this a stable fix? I get its a
> > > feature that is important and likely overlooked / someone had a brain
> > > fart, but from what I gather this is not on v3.5.4 and yet may make it
> > > to v3.5.5. At least for backporting this was a bitch:
> 
> <snip>
> 
> > Yes, this patch is wrongly marked as stable, it is not even going to 3.5. I'm
> > just removing the tag from it and resending the pull request to John.
> 
> Hmmm...well, I already pulled it, and I just pushed it out.  Can we live with it?

Yes, that would be ok for me.

	Gustavo
