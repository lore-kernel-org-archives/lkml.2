Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab1FFPjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:39:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39308 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757416Ab1FFPjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:39:02 -0400
Date: Mon, 6 Jun 2011 11:38:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tatyana Brokhman <tlinder@codeaurora.org>
cc: greg@kroah.com, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 10/10] usb:dummy_hcd: Force FS device connection
 according to module parameter
In-Reply-To: <1307360469-29120-10-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1106061138060.1953-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jun 2011, Tatyana Brokhman wrote:

> This patch adds a new module parameter to dummy_hcd: is_high_speed
> When set to false the connected device will be forced to operate in FS
> mode. The default of this parameter is true.

You might want to print out some kind of error message if the user 
specifies is_super_speed = True and is_high_speed = False.

Alan Stern

