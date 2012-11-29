Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab2K2FPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:15:55 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38790 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836Ab2K2FPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:15:52 -0500
X-Sasl-enc: hpuRaG0W/5J1wD2nA0iJY4HccZbU9IW0fGUxyPor5OAw 1354166152
Date: Wed, 28 Nov 2012 21:17:30 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bill Pemberton <wfp5p@virginia.edu>,
        Simon Guinot <simon.guinot@sequanux.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 driver-core tree
Message-ID: <20121129051730.GD4375@kroah.com>
References: <20121129160309.7dc352f433d39f1bde0018a8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129160309.7dc352f433d39f1bde0018a8@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 04:03:09PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/leds/leds-ns2.c between commit 98ea1ea20cb7 ("leds: remove use of
> __devinit") from the driver-core tree and commit 72052fcc1026 ("leds:
> leds-ns2: add device tree binding") from the arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks.

greg k-h
