Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab1CMVIV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 17:08:21 -0400
Received: from verein.lst.de ([213.95.11.211]:47235 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab1CMVIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 17:08:18 -0400
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Mar 2011 17:08:18 EDT
Date: Sun, 13 Mar 2011 21:59:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        Jonathan Nieder <jrnieder@gmail.com>, akpm@linux-foundation.org,
        linux-api@vger.kernel.org, arnd@arndb.de, mtk.manpages@gmail.com,
        viro@zeniv.linux.org.uk, hch@lst.de, linux-arch@vger.kernel.org
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Message-ID: <20110313205911.GA4239@lst.de>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net> <20110303072223.GA28133@elie> <87bp1sziqn.fsf@linux.vnet.ibm.com> <Pine.LNX.4.64.1103071515070.11152@cobra.newdream.net> <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * sync a single super
> + */

Not exactly the most descriptive comment.

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

