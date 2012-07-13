Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320Ab2GMOLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 10:11:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60804 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757585Ab2GMOLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 10:11:35 -0400
Date: Fri, 13 Jul 2012 10:11:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] usb/host/ehci-hub: Fix the issue EG20T USB host
 controller has long resuming time, when pen drive is attached.
In-Reply-To: <1342147422-5533-1-git-send-email-tomoya.rohm@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1207131011130.1261-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012, Tomoya MORINAGA wrote:

> Intel EG20T USB host controller does not send SOF in resuming time after
> suspending, if the FLR bit was not cleared. When pen drive is attached,
> the controller has a long resuming time to try re-connect it.
> This patch clear the FLR bit in suspending time for fixing the issue.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
> ---
> v3: Update comments from Alan Stern
> 	Add comment in the source code.
> 
> v2: Update comments from Alan Stern
>         Add patch description
>         Always clear the STS_FLR flag.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

