Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab2E0QDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 12:03:49 -0400
Received: from netrider.rowland.org ([192.131.102.5]:39930 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752740Ab2E0QD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 12:03:27 -0400
Date: Sun, 27 May 2012 12:03:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Michal Nazarewicz <mina86@mina86.com>
cc: Felipe Balbi <balbi@ti.com>, <panto@antoniou-consulting.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: f_mass_storage: change default value of
 the removable parameter
In-Reply-To: <9f033e3d3b2bcbdbf02253de540174479c0dd945.1338074060.git.mina86@mina86.com>
Message-ID: <Pine.LNX.4.44L0.1205271201460.14937-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 May 2012, Michal Nazarewicz wrote:

> This commit changes the default value of the removable module parameter
> from “y” to “n”.  This comes with line with file_storag's default and
> seems to be a better default.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>  drivers/usb/gadget/f_mass_storage.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> Alternatively I can add a warning about the default being changed and
> schedule the change for the future.  Dunno if it's worth it.

I think this patch is good as it stands.

Would you like to write a gadget-mass-storage.txt file for 
Documentation/usb?  Putting all the instructions for using the 
mass-storage gadget in a recognized place would help people to find it.

Alan Stern

