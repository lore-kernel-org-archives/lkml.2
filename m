Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab1HLOAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 10:00:24 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48944 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab1HLOAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 10:00:20 -0400
Date: Fri, 12 Aug 2011 09:51:02 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, Greg KH <gregkh@suse.de>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Raja Mani <rmani@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (wireless & staging trees related)
Message-ID: <20110812135101.GA2286@tuxdriver.com>
References: <20110811155529.e5f47afa0504c4ddef58ab37@canb.auug.org.au>
 <4E438D56.5020801@qca.qualcomm.com>
 <20110811141604.GA14763@suse.de>
 <4E43FA61.1010301@qca.qualcomm.com>
 <20110812121216.28e6979b44bacb651849640b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812121216.28e6979b44bacb651849640b@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 12:12:16PM +1000, Stephen Rothwell wrote:
> Hi Kalle, Greg,
> 
> On Thu, 11 Aug 2011 18:50:57 +0300 Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> >
> > On 08/11/2011 05:16 PM, Greg KH wrote:
> > > On Thu, Aug 11, 2011 at 11:05:42AM +0300, Kalle Valo wrote:
> > >
> > >> Yes, the cleaned up version of ath6kl is now in wireless-next and the
> > >> staging version can be removed in 3.2. Greg, how do you want to handle
> > >> removal of the staging version? Should I send a patch to you removing
> > >> it? Or should I send the patch to John?
> > > 
> > > Just tell me.  Should I really delete drivers/staging/ath6kl/ for the
> > > 3.2 kernel release?  If so, I'll gladly do so in my tree so linux-next
> > > will be fine for issues like this in the future.
> > 
> > Yes, please delete ath6kl from staging for the 3.2 release as the
> > cleanup version is now in wireless-next.
> > 
> > Thank you everyone and sorry for the mess.
> 
> I think that the removal should be done in the wirelesss tree so that
> Linus' tree is not broken during the next merge window.
> 
> I have added the removal patch as a merge fixup one the merge of the
> wireless tree for today.

Makes sense to me -- probably also is more sane if there is some fool
out there relying on the ath6kl driver in staging that doesn't know
about the switch to the wireless tree.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
