Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab1HXBaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 21:30:15 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:40204 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab1HXBaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 21:30:09 -0400
Subject: Re: linux-next: manual merge of the net tree with the unicore32
 tree
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: jeffrey.t.kirsher@intel.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Shu <davidshuzhang@gmail.com>,
        Chu Xiaowei <chuxiaowei@mprc.pku.edu.cn>,
        Su Yonggang <tonyhook.su@gmail.com>
In-Reply-To: <1314090049.2128.224.camel@jtkirshe-mobl>
References: <20110823130210.766d466d689d60536f59340a@canb.auug.org.au>
	 <1314090049.2128.224.camel@jtkirshe-mobl>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Wed, 24 Aug 2011 09:28:42 +0800
Message-ID: <1314149322.29738.14.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 02:00 -0700, Jeff Kirsher wrote:
> On Mon, 2011-08-22 at 20:02 -0700, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next merge of the net tree got conflicts in
> > drivers/net/Kconfig and drivers/net/Makefile between commit
> > e8787de6fa83
> > ("unicore32: add pkunity-v3 mac/net driver (umal)") from the unicore32
> > tree and the network driver rearrangement from the net tree.
> > 
> > I just added the new driver from the unicore32 tree commit into each
> > file
> > (see below).
> > -- 
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au 
> 
> Hmm, well with the latest series of patches I sent out, I am pretty sure
> this patch would not apply.
Ok, I see.
Thanks Jeff, and thanks Stephen.

Guan Xuetao

> 
> Is it best that this patch not be sent to netdev for driver
> inclusion? :)


