Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0DHIDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 04:03:10 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:40216 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab0DHIC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 04:02:57 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: USB transfer_buffer allocations on 64bit systems
Date: Thu, 8 Apr 2010 08:12:04 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
       Pedro Ribeiro <pedrib@gmail.com>, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org,
       linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.1004071120200.1779-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1004071120200.1779-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004080812.04419.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 7. April 2010 17:46:17 schrieb Alan Stern:
> Or alternatively, instead of allocating regular memory the routine
> could simply fail.  Then the caller would be responsible for checking
> and using regular memory instead of dma-consistent memory.  Of course,
> that would put an even larger burden on the caller than just forcing it
> to keep track of what flag to use.

Then it would be sensible to pass it a filled URB, modify it or return
an error code.

	Regards
		Oliver
