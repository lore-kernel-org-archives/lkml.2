Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab1GGPQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:16:26 -0400
Received: from ist.d-labs.de ([213.239.218.44]:53194 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab1GGPQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:16:25 -0400
MIME-Version: 1.0
In-Reply-To: <CACTFLAN=GOw8KLtvVBM6omvYzW3RBHggv-Kc2_2QVD--M-Jxkg@mail.gmail.com>
References: <CACTFLANCYMXH=z+NxEF0aqpMGZp21Q16_uB=J3rndM3pW74qeA@mail.gmail.com>
	<201107071433.42081.oliver@neukum.org>
	<CACTFLAN=GOw8KLtvVBM6omvYzW3RBHggv-Kc2_2QVD--M-Jxkg@mail.gmail.com>
Date: Thu, 7 Jul 2011 17:16:20 +0200
Message-ID: <CAGxyxNCjyoiAdniT9z7af31TETuO1u1RksTCXm6wnWR8oOaYPA@mail.gmail.com>
Subject: Re: Allocating buffers for USB transfers (again)
From: Florian Mickler <florian@mickler.org>
To: Daniel Mack <zonque@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Clemens Ladisch <clemens@ladisch.de>, pedrib@gmail.com,
        William Light <wrl@illest.net>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding Robert Hancock]
see here for the whole thread: https://lkml.org/lkml/2011/7/7/150

2011/7/7 Daniel Mack <zonque@gmail.com>:
> On Thu, Jul 7, 2011 at 2:33 PM, Oliver Neukum <oliver@neukum.org> wrote:
>
>> PS:  Do you still see this if you enable 64bit DMA for EHCI?
>
> The problem is that I personally don't see that issue at all. I even
> installed 4GB of RAM to my development machine last year to be able to
> reproduce this, but I can't, even when the memory allocator is under
> heavy load. The only people who see this effect are Pedro Ribeiro and
> William Light (both in Cc:), and both have been very helpful in trying
> patches and reporting back in detail. Which instructions could we
> probably give to these people to finally hunt this issue down?
>
> Daniel
>
>

Did someone affected already try the suggestions from Robert :
http://lkml.org/lkml/2010/4/10/66

That is checking if it really is a 64bit vs 32bit issue by booting
with mem=4096M ?


Regards,
Flo
