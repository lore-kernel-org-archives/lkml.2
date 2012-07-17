Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab2GQOUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 10:20:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55650 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754494Ab2GQOUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 10:20:37 -0400
Date: Tue, 17 Jul 2012 10:20:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vivek Gautam <gautam.vivek@samsung.com>
cc: greg@kroah.com, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <l.majewski@samsung.com>, <a.kesavan@samsung.com>,
        <prashanth.g@samsung.com>, <kmpark@infradead.org>, <joshi@samsung.com>,
        <olofj@google.com>, <thomas.abraham@linaro.org>,
        <sshtylyov@mvista.com>, <jy0922.shim@samsung.com>,
        <jg1.han@samsung.com>
Subject: Re: [PATCH RESEND v4] USB: ehci-s5p: Add vbus setup function to the
 s5p ehci glue layer
In-Reply-To: <1342523006-8379-2-git-send-email-gautam.vivek@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1207171020220.1315-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2012, Vivek Gautam wrote:

> This patch retrieves and configures the vbus control gpio via
> the device tree. The suspend/resume callbacks will be later
> modified for vbus control.
> 
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

