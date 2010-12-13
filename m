Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab0LMVer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:34:47 -0500
Received: from cantor.suse.de ([195.135.220.2]:56493 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177Ab0LMVep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:34:45 -0500
Date: Mon, 13 Dec 2010 13:19:09 -0800
From: Greg KH <gregkh@suse.de>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbip: remove double giveback of URB
Message-ID: <20101213211909.GA19972@suse.de>
References: <4D06891D.3060605@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D06891D.3060605@freemail.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 09:59:09PM +0100, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> In the vhci_urb_dequeue() function the TCP connection is checked twice.
> Each time when the TCP connection is closed the URB is unlinked and given
> back. Remove the second attempt of unlinking and giving back of the URB completely.
> 
> This patch fixes the bug described at https://bugzilla.kernel.org/show_bug.cgi?id=24872 .
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>

Wow, nice catch, I wonder how it survived this long in working condition
:)

I'll queue this up right away, thanks so much for this patch.

greg k-h
