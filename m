Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab1GGNGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:06:13 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:47905 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577Ab1GGNGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:06:12 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Daniel Mack <zonque@gmail.com>
Subject: Re: Allocating buffers for USB transfers (again)
Date: Thu, 7 Jul 2011 15:08:43 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc5-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-usb@vger.kernel.org, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, Clemens Ladisch <clemens@ladisch.de>,
        florian@mickler.org, pedrib@gmail.com, William Light <wrl@illest.net>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <CACTFLANCYMXH=z+NxEF0aqpMGZp21Q16_uB=J3rndM3pW74qeA@mail.gmail.com> <201107071433.42081.oliver@neukum.org> <CACTFLAN=GOw8KLtvVBM6omvYzW3RBHggv-Kc2_2QVD--M-Jxkg@mail.gmail.com>
In-Reply-To: <CACTFLAN=GOw8KLtvVBM6omvYzW3RBHggv-Kc2_2QVD--M-Jxkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107071508.43988.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 7. Juli 2011, 14:38:51 schrieb Daniel Mack:
> On Thu, Jul 7, 2011 at 2:33 PM, Oliver Neukum <oliver@neukum.org> wrote:
> 
> > PS:  Do you still see this if you enable 64bit DMA for EHCI?
> 
> The problem is that I personally don't see that issue at all. I even
> installed 4GB of RAM to my development machine last year to be able to
> reproduce this, but I can't, even when the memory allocator is under
> heavy load. The only people who see this effect are Pedro Ribeiro and
> William Light (both in Cc:), and both have been very helpful in trying
> patches and reporting back in detail. Which instructions could we
> probably give to these people to finally hunt this issue down?

Do they have an IOMMU or are they using bounce buffers?
If the latter, you might be able to reproduce it if you disable your
IOMMU.

	Regards
		Oliver
