Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab1FOPko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 11:40:44 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:50344 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755366Ab1FOPkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 11:40:18 -0400
X-Sasl-enc: z2No/kmT4s1p8pwKIHhMX9AB7J3lUyNAzcLPNC9YeoFv 1308152417
Date: Wed, 15 Jun 2011 08:38:16 -0700
From: Greg KH <greg@kroah.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: device plugged into xhci port not detected after a resume
Message-ID: <20110615153816.GC10160@kroah.com>
References: <4DF85A1F.1080001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF85A1F.1080001@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 09:07:11AM +0200, Maarten Lankhorst wrote:
> I plugged a simple usb mouse in xhci that isn't found after a resume.

What kernel version are you using?

