Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3AGXWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 18:22:12 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41624 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3AGXWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 18:22:10 -0500
Date: Mon, 7 Jan 2013 15:22:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] staging/fwserial: Address reviewer comments
Message-ID: <20130107232206.GA15244@kroah.com>
References: <1355551400-8204-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355551400-8204-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 01:03:14AM -0500, Peter Hurley wrote:
> Overdue respin.
> v2 changes:
>    Don't use 'card' when referring to firewire node
>    Removed lower clamp in link_speed_to_max_payload()
>    Ripped out the bandwidth limit logic
>    Drop suggestion to integrate link_speed_to_max_payload()
>      & device_max_receive()
>    Note required minimum max_rec value for OHCI-compliant devices

Ugh, I applied the first version of this series, many apologies.  Can
you send me follow-on patches with just the differences here?

thanks,

greg k-h
