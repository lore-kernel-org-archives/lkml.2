Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab1ADF3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 00:29:54 -0500
Received: from kroah.org ([198.145.64.141]:48029 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab1ADF3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 00:29:52 -0500
Date: Mon, 3 Jan 2011 21:29:18 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mac Lin <mkl0301@gmail.com>, Anton Vorontsov <cbouatmailru@gmail.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Deepak Sikri <deepak.sikri@st.com>, Viresh Kumar <viresh.kumar@st.com>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>
Subject: Re: linux-next: manual merge of the usb tree with the arm tree
Message-ID: <20110104052918.GA14119@kroah.com>
References: <20110104155513.e8c36240.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104155513.e8c36240.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 03:55:13PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/Kconfig between commit
> 760efe6910d5743084b586d3d0a3b65aea96fb2f ("USB: cns3xxx: Add EHCI and
> OHCI bus glue for cns3xxx SOCs") from the arm tree and commits
> c8c38de9d8002578599222296b90696745ac0fe3 ("USB host: Adding USB ehci &
> ohci support for spear platform") and
> b0848aea10da186372582f33152efdda43944f26 ("USB: EHCI: Add MSM Host
> Controller driver") from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Thanks, that looks fine.

greg k-h
