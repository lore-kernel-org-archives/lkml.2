Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab2JATps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:45:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34017 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754368Ab2JATpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:45:47 -0400
Date: Mon, 1 Oct 2012 15:45:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Octavian Purdila <octavian.purdila@intel.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb hub: send clear_tt_buffer_complete events when
 canceling TT clear work
In-Reply-To: <1349119272-21682-1-git-send-email-octavian.purdila@intel.com>
Message-ID: <Pine.LNX.4.44L0.1210011544570.1183-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2012, Octavian Purdila wrote:

> There is a race condition in the USB hub code with regard to handling
> TT clear requests that can get the HCD driver in a deadlock. Usually
> when an TT clear request is scheduled it will be executed immediately:

...

> This patch changes hub_quiesce behavior to flush the TT clear work
> instead of canceling it, to make sure that no TT clear request remains
> uncompleted before suspend.
> 
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

