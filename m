Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab2CMVSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:18:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48302 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2CMVSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:18:02 -0400
Date: Tue, 13 Mar 2012 14:17:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] usb: Don't make USB_ARCH_HAS_OHCI and USB_ARCH_HAS_EHCI
 depend on USB_SUPPORT.
Message-ID: <20120313211758.GA10168@kroah.com>
References: <1331578904-15561-1-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331578904-15561-1-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 12:01:44PM -0700, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> The fact that an architecture/board has OHCI or EHCI does not depend on
> the fact that the kernel is configured with USB_SUPPORT.

Why are you ignoring XHCI here as well?  Shouldn't that fall under the
same rules as OHCI and EHCI (hint, they should...)

thanks,

greg k-h
