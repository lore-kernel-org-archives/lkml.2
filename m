Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1EEN53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 09:57:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60369 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754160Ab1EEN51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 09:57:27 -0400
Date: Thu, 5 May 2011 09:57:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tony Vroon <tony@linx.net>
cc: linux-usb@vger.kernel.org, <usb-storage@lists.one-eyed-alien.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: ums-realtek: Unneeded SubClass & Protocol entries (Fujitsu S760
 laptop)
In-Reply-To: <4DC26B50.7070604@linx.net>
Message-ID: <Pine.LNX.4.44L0.1105050955270.1893-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011, Tony Vroon wrote:

> On 05/04/11 17:35, Alan Stern wrote:
> > Does the patch below cause the message to 
> > go away?
> 
> Tested-By: Tony Vroon <tony@linx.net>
> 
> - -ums-realtek 1-1.6:1.0: This device (0bda,0138,3882 S 06 P 50) has
> unneeded SubClass and Protocol entries in unusual_devs.h (kernel
> 2.6.39-rc5-00274-g609cfda)
> - -   Please send a copy of this message to <linux-usb@vger.kernel.org>
> and <usb-storage@lists.one-eyed-alien.net>
> 
> That is with your patch applied to 2.6.39-rc6-00041-g5895198. Many thanks.

Sorry, I don't quite understand what you mean.  Do those "- -" strings 
indicate that the message is not present when the patch is applied?

Alan Stern

