Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934148Ab2JLQxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:53:24 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52492 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932562Ab2JLQxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:53:21 -0400
Message-ID: <1350060799.2243.31.camel@joe-AO722>
Subject: Re: [PATCH 2/9] Staging: winbond: phy_calibration: Fixed coding
 style issue
From: Joe Perches <joe@perches.com>
To: Adil Mujeeb <mujeeb.adil@gmail.com>
Cc: pavel@ucw.cz, gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Fri, 12 Oct 2012 09:53:19 -0700
In-Reply-To: <1350059835-5408-3-git-send-email-mujeeb.adil@gmail.com>
References: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
	 <1350059835-5408-3-git-send-email-mujeeb.adil@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 22:07 +0530, Adil Mujeeb wrote:
> Removed checkpatch.pl script reported ERRORs
[]
> diff --git a/linux-3.6-rc7/drivers/staging/winbond/phy_calibration.c b/linux-3.6-rc7/drivers/staging/winbond/phy_calibration.c
[]
> -#define AG_CONST        0.6072529350
> +#define AG_CONST        (0.6072529350)

That one is unnecessary.
checkpatch is defective here.

I wonder why there is any floating point
in the code at all though.


