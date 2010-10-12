Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab0JLRac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 13:30:32 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49497 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab0JLRab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 13:30:31 -0400
Date: Tue, 12 Oct 2010 13:15:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Ben Greear <greearb@candelatech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath5k: fix build break from "ath5k: Print out opmode in
 debugfs"
Message-ID: <20101012171510.GB2403@tuxdriver.com>
References: <20101012163519.a88f2040.sfr@canb.auug.org.au>
 <1286895206-3030-1-git-send-email-linville@tuxdriver.com>
 <1286898204.1117.47.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286898204.1117.47.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 08:43:24AM -0700, Joe Perches wrote:
> On Tue, 2010-10-12 at 10:53 -0400, John W. Linville wrote:
> > Without this and with CONFIG_ATH_DEBUG not set...
> > ERROR: ".ath_opmode_to_string" [drivers/net/wireless/ath/ath5k/ath5k.ko] undefined!
> 
> Perhaps this instead?

Thanks, I like yours better. :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
