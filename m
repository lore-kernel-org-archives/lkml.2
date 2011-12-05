Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab1LEPtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 10:49:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:59023 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420Ab1LEPtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 10:49:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,299,1320652800"; 
   d="scan'208";a="82348556"
Subject: Re: linux-next: manual merge of the net-next tree with the  tree
From: wwguy <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>
In-Reply-To: <20111205145320.GA2531@tuxdriver.com>
References: <20111205123428.47213da24624d85aa84711f3@canb.auug.org.au>
	 <20111205153416.e1dd01e5368ce7c016d99a59@canb.auug.org.au>
	 <20111205145320.GA2531@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Dec 2011 07:42:56 -0800
Message-ID: <1323099776.5536.0.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 06:53 -0800, John W. Linville wrote:
> On Mon, Dec 05, 2011 at 03:34:16PM +1100, Stephen Rothwell wrote:
> > On Mon, 5 Dec 2011 12:34:28 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >
> > > Today's linux-next merge of the net-next tree got a conflict in
> > > drivers/net/wireless/iwlwifi/iwl-agn.c between commits from the
> > 
> > wireless (sorry)
> > 
> > > tree and commit 7335613ae27a ("iwlwifi: move all mac80211 related
> > > functions to one place") from the net-next tree.
> > > 
> > > I just used the net-next version (which may require some fixes).
> 
> Yeah, I'll try to get that straightened-out over the next day or two.
> 
John, anything I can help?

Thanks
Wey
 


