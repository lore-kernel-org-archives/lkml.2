Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab0CaOIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 10:08:05 -0400
Received: from londo.lunn.ch ([80.238.139.98]:48280 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755Ab0CaOID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 10:08:03 -0400
X-Greylist: delayed 1437 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Mar 2010 10:08:03 EDT
Date: Wed, 31 Mar 2010 15:43:35 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Dan Milway <dan.milway@gmail.com>
Cc: gregkh@suse.de, andrew@lunn.ch, lindner_marek@yahoo.de,
       siwu@hrz.tu-chemnitz.de, linus.luessing@web.de,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: batman-adv: fix whitespace coding style issue
 in proc.c This is a patch to the proc.c file that fixes several whitespace
 warnings found by the checkpatch.pl tool Signed-off by: Dan Milway
 <dan.milway@gmail.com>
Message-ID: <20100331134335.GA10849@lunn.ch>
References: <1270007019-12414-1-git-send-email-dan.milway@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270007019-12414-1-git-send-email-dan.milway@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan

Thanks for the patch.

I think all of these have already been fixed in a patch i sent to Greg
for the next -rc kernel. There is a bug proc.c, and while fixing the
bug i took the time to fix these white space things as well.

Please could you check this file again after the next -rc kernel is
released?

	Thanks
		Andrew
