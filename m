Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab2LSIem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 03:34:42 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58864 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752768Ab2LSIec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 03:34:32 -0500
Date: Wed, 19 Dec 2012 09:34:30 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "greg@kroah.com" <greg@kroah.com>, "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        Huqiao <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>
Subject: Re: [PATCH 2/2]linux-usb:optimize to match the Huawei USB storage
 devices and support new switch command
Message-ID: <20121219083430.GB3400@breakpoint.cc>
References: <fdcd8d23149d.149dfdcd8d23@huawei.com>
 <fdcdb3e12b55.2b55fdcdb3e1@huawei.com>
 <20121218141013.GB4939@breakpoint.cc>
 <910F9D9E13B84F4C8FA771DC9BDE99F326FCB006@szxeml546-mbs.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <910F9D9E13B84F4C8FA771DC9BDE99F326FCB006@szxeml546-mbs.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 03:13:32AM +0000, Fangxiaozhi (Franko) wrote:
> 	By the way, I found the kernel is updated to 3.7.1 today. So I have to update my patch based on 3.7.1, and resubmit it?
> 	Right?

You should rebase your patch on top of Greg's usb-next branch of his usb tree.
 http://git.kernel.org/?p=linux/kernel/git/gregkh/usb.git;a=shortlog;h=refs/heads/usb-next

but I guess that there are hardly any changes in that area. The last change in
drivers/usb/storage/initializers.* is yours "USB: usb-storage fails to attach
to Huawei Datacard cdrom device".

If you call ./scripts/get_maintainer.pl on your patch you should learn that
you miss
|Matthew Dharm <mdharm-usb@one-eyed-alien.net>
|usb-storage@lists.one-eyed-alien.net

> > And shouldn't you read something from the us->recv_bulk_pipe after
> > that?
> 	Well, because our device will re-connect to switch the ports if it receives the command.
> 	So it is not necessary to read the response of the command.

Hmm. I guess this for Matthew / Greg to decide, I don't insist on anything.
Maybe a comment would be nice because now it looks, atleast to me, that
something is missing.

Sebastian
