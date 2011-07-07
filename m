Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab1GGMiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 08:38:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44228 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab1GGMiv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 08:38:51 -0400
MIME-Version: 1.0
In-Reply-To: <201107071433.42081.oliver@neukum.org>
References: <CACTFLANCYMXH=z+NxEF0aqpMGZp21Q16_uB=J3rndM3pW74qeA@mail.gmail.com>
	<201107071433.42081.oliver@neukum.org>
Date: Thu, 7 Jul 2011 14:38:51 +0200
Message-ID: <CACTFLAN=GOw8KLtvVBM6omvYzW3RBHggv-Kc2_2QVD--M-Jxkg@mail.gmail.com>
Subject: Re: Allocating buffers for USB transfers (again)
From: Daniel Mack <zonque@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, Clemens Ladisch <clemens@ladisch.de>,
        florian@mickler.org, pedrib@gmail.com, William Light <wrl@illest.net>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 2:33 PM, Oliver Neukum <oliver@neukum.org> wrote:

> PS:  Do you still see this if you enable 64bit DMA for EHCI?

The problem is that I personally don't see that issue at all. I even
installed 4GB of RAM to my development machine last year to be able to
reproduce this, but I can't, even when the memory allocator is under
heavy load. The only people who see this effect are Pedro Ribeiro and
William Light (both in Cc:), and both have been very helpful in trying
patches and reporting back in detail. Which instructions could we
probably give to these people to finally hunt this issue down?

Daniel
