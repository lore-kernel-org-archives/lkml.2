Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1G1GGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 02:06:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62216 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab1G1GGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 02:06:23 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/2] ASIX: Use only 11 bits of header for data size
Date: Thu, 28 Jul 2011 08:06:18 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-1-amd64; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, gregkh@suse.de
References: <1311734687-23551-1-git-send-email-marek.vasut@gmail.com> <1311734687-23551-2-git-send-email-marek.vasut@gmail.com> <20110727.224029.619127041796367339.davem@davemloft.net>
In-Reply-To: <20110727.224029.619127041796367339.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107280806.18813.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 28, 2011 07:40:29 AM David Miller wrote:
> From: Marek Vasut <marek.vasut@gmail.com>
> Date: Wed, 27 Jul 2011 04:44:47 +0200
> 
> > The AX88772B uses only 11 bits of the header for the actual size. The
> > other bits
> > 
> > are used for something else. This causes dmesg full of messages:
> > 	asix_rx_fixup() Bad Header Length
> > 
> > This patch trims the check to only 11 bits. I believe on older chips, the
> > remaining 5 top bits are unused.
> > 
> > Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> 
> Applied.

Hi, did you test it ?

I left NOTEs outside the commit message:

NOTE: If possible, can someone test/verify this patch with other ASIX chips ?
NOTE2: If Ack-ed, Greg, can you get this into -stable?

I hope I won't have a horde of angry people at my door soon ;-)
