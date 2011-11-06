Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab1KFWyn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 17:54:43 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35605 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab1KFWyl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 17:54:41 -0500
MIME-Version: 1.0
In-Reply-To: <20110920161743.GA32737@kroah.com>
References: <20110920161743.GA32737@kroah.com>
Date: Sun, 6 Nov 2011 23:54:39 +0100
Message-ID: <CAHR064gzgKtLSNQ-NuoKWW9-Nv_S0myOusQT+-CxVVeyO5fMKA@mail.gmail.com>
Subject: Re: [patch 0/8] Samsung Laptop driver patches - resend
From: Corentin Chary <corentin.chary@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, greg@kroah.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 6:17 PM, Greg KH <gregkh@suse.de> wrote:
> Hi Matthew,
>
> Here is a resend of the samsung-laptop patches, with the correct
> authorship info in it.  Sorry about the last batch, 'quilt mail' strips
> them off when sending them out, despite the information being in the
> original patch.
>
> The patches are against Linus's current tree, but should apply just fine
> to linux-next as well.
>
> If there are any problems with them, please let me know.
>
> Oh, and if anyone wants to take over maintainership of this driver,
> please let me know.  I no longer have the hardware to be able to test
> any changes for it, which is why this took so long to get pushed out to
> you.
>
> thanks,
>
> greg k-h

Hi Greg,

Just got a 90X3A from Intel and I'll try to take a look at samsung-laptop
since some features are missing (keyboard backlight for example).

Do you have any doc on the vendor "interface" (other than just reading
the code :) ) ?

Thanks,

-- 
Corentin Chary
http://xf.iksaif.net
