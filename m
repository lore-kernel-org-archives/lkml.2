Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab0HSPSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:18:01 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40389 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab0HSPSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:18:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=By0Q7aAloFt4owybjqYJOgsdtiaWsemRakxqybKlzTqRqnkQlbUjHoPQp3JcRoBAqi
         1xdhkyHWCLVOxM9V/KKBAEq01G6+UHdQHbVyVRJVKCv6Ofh45gTVBtZuKrs80gKZAOTE
         VpJ+G0sXMYvvMuhnxfXT4FhdkMdWTE/Ronwyk=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1008191038100.1680-100000@iolanthe.rowland.org>
References: <AANLkTi=m8GPqj2g9GXK+Kmh2dpeCba7vfyGaax3AWZjz@mail.gmail.com>
	<Pine.LNX.4.44L0.1008191038100.1680-100000@iolanthe.rowland.org>
Date: Thu, 19 Aug 2010 23:17:58 +0800
Message-ID: <AANLkTi=eagJAmotQv+WPJTLkxt8of99=5m3=kehVo79p@mail.gmail.com>
Subject: Re: RIP: 0010:[<ffffffff81495d87>] [<ffffffff81495d87>] _raw_spin_lock_irq+0x1b/0x2b
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: lkml <linux-kernel@vger.kernel.org>, Petr Vandrovec <petr@vmware.com>,
        Linux USB <linux-usb@vger.kernel.org>,
        Adrian Drzewiecki <adriand@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 10:34 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, Aug 19, 2010 at 09:16:26AM +0800, Jeff Chua wrote:
>> Not sure if this is a vmware bug or kernel, so I'm posting it here.
>> Tried to upgrade my iPhone4 iOS to 4.0.2 running a VMware guest with
>> Linux-2.6.35+ and Linux-2.6.36-rc1, and both has the same problem.
>
> Known issue, the fix is now in Linus's tree.


On Thu, Aug 19, 2010 at 10:39 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 19 Aug 2010, Jeff Chua wrote:

> Try using the most recent git source, or else apply commit
> 9c9e54a8df0be48aa359744f412377cc55c3b7d2 (HID: hiddev: fix memory
> corruption due to invalid intfdata).


Alan, Greg,

Thanks for the pointer. I git pulled and saw the commit. Will
monitored for a while.

Thanks,
Jeff
