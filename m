Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab1HLRfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:35:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40922 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab1HLRfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:35:15 -0400
Date: Fri, 12 Aug 2011 10:32:55 -0700
From: Greg KH <gregkh@suse.de>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Raja Mani <rmani@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (wireless & staging trees related)
Message-ID: <20110812173255.GE14182@suse.de>
References: <20110811155529.e5f47afa0504c4ddef58ab37@canb.auug.org.au>
 <4E438D56.5020801@qca.qualcomm.com>
 <20110811141604.GA14763@suse.de>
 <4E43FA61.1010301@qca.qualcomm.com>
 <20110812121216.28e6979b44bacb651849640b@canb.auug.org.au>
 <20110812135101.GA2286@tuxdriver.com>
 <4E453502.4000401@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E453502.4000401@qca.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 05:13:22PM +0300, Kalle Valo wrote:
> On 08/12/2011 04:51 PM, John W. Linville wrote:
> > On Fri, Aug 12, 2011 at 12:12:16PM +1000, Stephen Rothwell wrote:
> >> On Thu, 11 Aug 2011 18:50:57 +0300 Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> >>>
> >>> Yes, please delete ath6kl from staging for the 3.2 release as the
> >>> cleanup version is now in wireless-next.
> >>>
> >>> Thank you everyone and sorry for the mess.
> >>
> >> I think that the removal should be done in the wirelesss tree so that
> >> Linus' tree is not broken during the next merge window.
> >>
> >> I have added the removal patch as a merge fixup one the merge of the
> >> wireless tree for today.
> > 
> > Makes sense to me -- probably also is more sane if there is some fool
> > out there relying on the ath6kl driver in staging that doesn't know
> > about the switch to the wireless tree.
> 
> Ok, I'll send a patch to John which removes the staging driver.

Ok, that is fine with me as well.

greg k-h
