Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab1BUN7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 08:59:15 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45115 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab1BUN7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 08:59:14 -0500
Date: Mon, 21 Feb 2011 13:58:31 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Mike Waychison <mikew@google.com>, Greg KH <greg@kroah.com>,
        torvalds@linux-foundation.org, San Mehat <san@google.com>,
        Aaron Durbin <adurbin@google.com>, Duncan Laurie <dlaurie@google.com>,
        linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>
Subject: Re: [PATCH v1 3/6] driver: Google EFI SMI
Message-ID: <20110221135831.GA13913@srcf.ucam.org>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com> <20110125002449.12637.35623.stgit@mike.mtv.corp.google.com> <20110125031752.GA9846@kroah.com> <AANLkTi=XhRX-=k8UmmQFshP6fgF_q2c-9gEHuH0mWu0a@mail.gmail.com> <20110126024608.GB28283@kroah.com> <AANLkTi=rO5QOVjNNWkekOb0WXzKX2CUpgvEryL0cemzB@mail.gmail.com> <AANLkTimT_t-3smsaQUrtisFdkODfoOoroQ93tQ9PByBq@mail.gmail.com> <AANLkTim27Y+TKa54jhC1VuqXzjEzX150ysGoUKNJrBmk@mail.gmail.com> <20110220044440.GA28167@auslistsprd01.us.dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110220044440.GA28167@auslistsprd01.us.dell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 10:44:40PM -0600, Matt Domsch wrote:

> I wrote that long before anyone believed there could be a 32-bit EFI
> or 32-bit kernel running on a 64-bit EFI.  Remember, this originated
> on Itanium.  I knew it was ugly, but the EFI spec itself defined the
> DataSize and Status as they did.

How can a 32-bit kernel run on 64-bit EFI? I've seen vendors who keep 
their EFI code above 4GB.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
