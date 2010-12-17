Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab0LQXQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 18:16:25 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:57332 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab0LQXQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 18:16:22 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2/2] USB: ehci: tegra: Align DMA transfers to 32 bytes
Date: Sat, 18 Dec 2010 00:17:40 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: rmorell@nvidia.com, David Brownell <dbrownell@users.sourceforge.net>,
        Benoit Goby <benoit@android.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>,
        Olof Johansson <olof@lixom.net>, Erik Gilling <konkers@android.com>,
        Colin Cross <ccross@android.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1292623129-26361-1-git-send-email-rmorell@nvidia.com> <20101217224221.GE25105@morell.nvidia.com> <20101217230940.GB21147@suse.de>
In-Reply-To: <20101217230940.GB21147@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012180017.41391.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 18. Dezember 2010, 00:09:40 schrieb Greg KH:
> I still don't like it, it feels like a hack that is not going to be able
> to be maintained very well.
> 
> And I still think the individual drivers should be fixed...
> 

But they are not buggy. The USB API was written under the
assumption that HCDs can deal with byte level granularity and alignment.
Hence the network driver pass DMA-able memory with an alignment
that suits them.

	Regards
		Oliver
