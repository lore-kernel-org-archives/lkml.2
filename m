Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab1D3A2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 20:28:15 -0400
Received: from kroah.org ([198.145.64.141]:42329 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760613Ab1D3A2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 20:28:12 -0400
Date: Fri, 29 Apr 2011 17:26:02 -0700
From: Greg KH <greg@kroah.com>
To: John Linn <john.linn@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, michal.simek@petalogix.com, joe@perches.com,
        grant.likely@secretlab.ca
Subject: Re: [PATCH V6] tty/serial: add support for Xilinx PS UART
Message-ID: <20110430002602.GA1818@kroah.com>
References: <64601bfb-0904-4741-8fc8-075a262c988c@VA3EHSMHS024.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64601bfb-0904-4741-8fc8-075a262c988c@VA3EHSMHS024.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 06:13:07PM -0600, John Linn wrote:
> The Xilinx PS Uart is used on the new ARM based SoC. This
> UART is not compatible with others such that a seperate
> driver is required.
> 
> Signed-off-by: John Linn <john.linn@xilinx.com>
> ---
> 
> V6 
> 
> Removed legal footer issues. My apologies Greg.

Nope, it's still there:

> 
> This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.
> 

{double sigh}

