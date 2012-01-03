Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab2ACQ24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 11:28:56 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:47871 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754039Ab2ACQ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 11:28:55 -0500
X-Sasl-enc: NtZLaeTlskeEIXuy7gtTIpbZjLzg+2BHc0WZd9y06Zxo 1325608134
Date: Tue, 3 Jan 2012 08:28:44 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the s5p tree
Message-ID: <20120103162844.GA26265@kroah.com>
References: <20120103180854.e9bff732db50c0fa9afd2967@canb.auug.org.au>
 <010601ccc9ef$7e784640$7b68d2c0$%kim@samsung.com>
 <CA+55aFzuEP7poPj_TiC28+T7Xn-6G1Lydt=q5FMVTj_XhOVf3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzuEP7poPj_TiC28+T7Xn-6G1Lydt=q5FMVTj_XhOVf3w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 08:20:20AM -0800, Linus Torvalds wrote:
> On Tue, Jan 3, 2012 at 12:12 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> >
> > OK, I see. Firstly, I will rebase my for-next as per your suggestion. As you
> > know, I just wanted to avoid known conflicts with driver-core tree.
> 
> Please, in general you should *not* rebase on top of other peoples
> trees either. What's the conflict and why do you need that other tree
> in the first place?

There's lots of merge conflicts with the driver-next tree due to some
changes we made there.  We'll work them out before they get pushed to
your tree.

thanks,

greg k-h
