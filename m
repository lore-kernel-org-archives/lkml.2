Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab2LXEsF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 23:48:05 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:38011 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2LXEsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 23:48:00 -0500
Date: Mon, 24 Dec 2012 12:48:18 +0800
From: Wang YanQing <udknight@gmail.com>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, bp@alien8.de, sakiwit@gmail.com,
        lacombar@gmail.com, lucas.demarchi@profusion.mobi, dave@gnu.org,
        paul.gortmaker@windriver.com, crquan@gmail.com, bpoirier@suse.de,
        yann.morin.1998@free.fr
Subject: Re: [PATCH] kconfig:lxdialog: remove duplicate code
Message-ID: <20121224044818.GA3863@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, mmarek@suse.cz,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	rdunlap@xenotime.net, bp@alien8.de, sakiwit@gmail.com,
	lacombar@gmail.com, lucas.demarchi@profusion.mobi, dave@gnu.org,
	paul.gortmaker@windriver.com, crquan@gmail.com, bpoirier@suse.de,
	yann.morin.1998@free.fr
References: <20121217143751.GA16993@udknight>
 <201212171919.07368.yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201212171919.07368.yann.morin.1998@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 07:19:07PM +0100, Yann E. MORIN wrote:
> Wang, All,
> 
> On Monday 17 December 2012 Wang YanQing wrote:
> > dialog.h has two line the same below:
> > extern char dialog_input_result[];
> > This patch remove one of them.
> > 
> > Signed-off-by: Wang YanQing <udknight@gmail.com>
> 
> Reviewed-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Michal, All.

Hi Michal, could you consider pick up this obvious right
patch, and consider others' three patch I sented one week
ago? I just don't want delay them to 2013, and they can get
more test when they appear in next tree.
https://patchwork.kernel.org/patch/1887361/
https://patchwork.kernel.org/patch/1894341/
https://patchwork.kernel.org/patch/1887441/

Happy christmas!

Thanks.
