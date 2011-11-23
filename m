Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab1KWEuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 23:50:14 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40759 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab1KWEuM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 23:50:12 -0500
MIME-Version: 1.0
In-Reply-To: <20111122195714.GA2815@xanatos>
References: <1321970616-1298-1-git-send-email-amandeep3986@gmail.com>
	<20111122195714.GA2815@xanatos>
Date: Wed, 23 Nov 2011 10:20:10 +0530
Message-ID: <CAJ54Ua4HgcDkWrcgVHNtNBmwgHh+Swn_Q2kKGLKS5+d94g07kQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] xHCI: Adding #define values used for hub descriptor
From: Aman Deep <amandeep3986@gmail.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sarah,


> >
> > Also use some #defines in places where magic numbers are being used.
>
> Looks fine to me for the xHCI changes.  I copied most of the hub
> descriptor code from EHCI, so it will need the same treatment.

Okay, thanks. I will try to make some of these changes into other host
controller drivers also as
soon as I can.

>
> Acked-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>

Thanks for the ACK, Sarah.

>
> The #defines look a bit odd to me, like you're using spaces instead of
> tabs to separate the name and value, or your mail program is converting
> tabs to spaces.  Do the numbers line up for you?

Actually, both the HUB_CHAR_TTTT and HUB_CHAR_PORTIND were already using
spaces instead of tabs. I just copied them to the lines below, thats
why they still have
spaces between define and value.

But thanks for info. I will take more care about this in future.

Do you want me to make any changes in this patch ?

>
> > Signed-off-by: Aman Deep <amandeep3986@gmail.com>
> > ---
