Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760521Ab0KRVJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:09:01 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53019 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759474Ab0KRVI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:08:59 -0500
Date: Thu, 18 Nov 2010 19:09:00 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (wireless tree related)
Message-ID: <20101118210900.GB3874@vigoh>
References: <20101117134820.bca8d764.sfr@canb.auug.org.au>
 <4CE3FCB5.6030909@oracle.com>
 <20101118132724.f7d21899.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118132724.f7d21899.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [2010-11-18 13:27:24 +1100]:

> Hi all,
> 
> On Wed, 17 Nov 2010 08:03:01 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >
> > On 11/16/10 18:48, Stephen Rothwell wrote:
> > > 
> > > After merging the final tree, today's linux-next build (powerpc allyesconfig)
> > > failed like this:
> > > 
> > > drivers/net/wireless/iwlwifi/iwl3945.o: In function `iwl_legacy_mac_reset_tsf':
> > > (.opd+0xf00): multiple definition of `iwl_legacy_mac_reset_tsf'
> > > drivers/net/wireless/iwlwifi/iwlagn.o:(.opd+0x90): first defined here
> 	.
> 	.
> > > I should have known when I reported the warning ...
> > > 
> > > Caused by commit dd0dd411f7178a20ea93a3cfa39123f078a07e25 ("iwlwifi: fix
> > > modular legacy build errors").
> > > 
> > > I have reverted that commit for today.
> > 
> > Ack.  John, please drop/revert that patch.
> > 
> > Sorry about the problem.
> 
> Looks like John removed it but the bluetooth tree (which is based on top
> of the wireless tree) brought it back in by rebasing on top of yesterday's
> wireless tree. :-(
> 
> I have reverted it again today.

Sorry about that, I wasn't aware of this problem. I'm going to redo my
tree today to fix this issue.

-- 
Gustavo F. Padovan
http://profusion.mobi
