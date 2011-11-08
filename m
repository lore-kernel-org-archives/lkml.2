Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab1KHBFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:05:23 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37776 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753905Ab1KHBFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:05:17 -0500
X-Sasl-enc: wf7uwFmdbYwWprWKd4dIHQE88mR517fisXo7GujJAEKc 1320714316
Date: Mon, 7 Nov 2011 17:03:09 -0800
From: Greg KH <greg@kroah.com>
To: Carla Sella <carla.sella@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: re-enabling wireless network on network manager does not
 work properly
Message-ID: <20111108010309.GB16800@kroah.com>
References: <4EB54800.2010408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB54800.2010408@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 05, 2011 at 03:28:16PM +0100, Carla Sella wrote:
> Hello,
> I'm reporting upstream a bug I already have reported in launchpad for
> Ubuntu.
> If you disable wireless networking on network manager and then re-enable
> it, wireless networks are not displayed anymore.

That's not a kernel bug at all, please report this to the network
manager developers.

good luck,

greg k-h
