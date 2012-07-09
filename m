Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab2GISsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:48:37 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:55346 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab2GISsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:48:35 -0400
Date: Mon, 9 Jul 2012 15:48:24 -0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Henrik Rydberg <rydberg@bitmath.se>
Cc: Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: Re: [PATCH] Bluetooth: Add MacBookPro10,1 support
Message-ID: <20120709184824.GA21411@x220>
Mail-Followup-To: Henrik Rydberg <rydberg@bitmath.se>,
	Gustavo Padovan <gustavo@padovan.org>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	Henrik Rydberg <rydberg@euromail.se>
References: <1341856347-257-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341856347-257-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Mon, Jul 09, 2012, Henrik Rydberg wrote:
> Add support for the 2012 15'' MacBook Pro Retina.
> 
> Patch originally written by clipcarl (forums.opensuse.org).
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Hi Gustavo,
> 
> This patch adds support for the new retina. Picked up from the suse
> forum. Getting it into 3.5 would be great, if possible.
> 
> Cheers,
> Henrik
> 
>  drivers/bluetooth/btusb.c | 3 +++
>  1 file changed, 3 insertions(+)

I believe the requirement is to always include a usb-devices output in
the commit message (to let maintainers confirm that no typo has occurred
in the patch itself).

Johah
