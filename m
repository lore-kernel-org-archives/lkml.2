Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab1BUCRc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 21:17:32 -0500
Received: from imr3.ericy.com ([198.24.6.13]:38120 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab1BUCRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 21:17:31 -0500
Date: Sun, 20 Feb 2011 18:17:08 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: linux-next: manual merge of the hwmon-staging tree with the
 jdelvare-hwmon tree
Message-ID: <20110221021708.GA7096@ericsson.com>
References: <20110221121944.57f2ecfb.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110221121944.57f2ecfb.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 08:19:44PM -0500, Stephen Rothwell wrote:
> Hi Guenter,
> 
> Today's linux-next merge of the hwmon-staging tree got a conflict in
> drivers/hwmon/Makefile between commits
> bb6cd76e2364b13de54314aeadd9f61b75335caa ("Let Kconfig handle lis3lv02d
> dependencies") and d8f00f1b531b25ac96a39385617ff1718bc8474b ("Move
> lis3lv02d drivers to drivers/misc") from the jdelvare-hwmon tree and
> commit 2c37a4a61ef4efaa7a802e0757d783d9b54ad064 ("hwmon: Add support for
> Lineage Compact Power Line PEM devices") from the hwmon-staging tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Hi Stephen,

yes, it would be great if you can carry the fix if it doesn't make too much trouble.
I don't see an easy way around it.

Thanks,
Guenter
