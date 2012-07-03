Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab2GCJWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:22:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab2GCJWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:22:23 -0400
Date: Tue, 3 Jul 2012 11:22:18 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the hid tree
In-Reply-To: <20120702121431.bf4119857a91068f395bcd21@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1207031122011.17304@pobox.suse.cz>
References: <20120702121431.bf4119857a91068f395bcd21@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2012, Stephen Rothwell wrote:

> Hi Jiri,
> 
> After merging the hid tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
> 
> drivers/hid/Kconfig:7:error: recursive dependency detected!
> drivers/hid/Kconfig:7:	symbol HID is selected by USB_HID
> drivers/hid/usbhid/Kconfig:4:	symbol USB_HID depends on HID

This is fixed in for-next branch I have just pushed. Thanks,

-- 
Jiri Kosina
SUSE Labs
