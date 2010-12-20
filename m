Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab0LTBk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 20:40:29 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:41951 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab0LTBk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 20:40:28 -0500
Date: Mon, 20 Dec 2010 10:38:58 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <damm@opensource.se>
Subject: Re: linux-next: manual merge of the rmobile tree with the rmobile-current tree
Message-ID: <20101220013858.GA10050@linux-sh.org>
References: <20101220123329.be4093ad.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220123329.be4093ad.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 12:33:29PM +1100, Stephen Rothwell wrote:
> Hi Paul,
> 
> Today's linux-next merge of the rmobile tree got a conflict in
> arch/arm/mach-shmobile/include/mach/entry-macro.S between commit
> 1cf215a5b43950d1a304373037828158057ff9fc ("ARM: mach-shmobile: INTC
> interrupt priority level demux fix") from the rmobile-current tree and
> commits 6d9598e24d50a8c72f48a3864327484a30aaee44 ("ARM: mach-shmobile:
> Initial AG5 and AG5EVM support") and
> 45bbaae0dcddc275594e23f108cb68869eae7433 ("ARM: mach-shmobile: Split out
> entry-macros in to GIC and INTC variants") from the rmobile tree.
> 
> I just used the version from the rmobile tree and will leave any fixup to
> you.

Ah, I forgot about that. I'll take care of it today, thanks.
