Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab1JJPTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:19:46 -0400
Received: from netrider.rowland.org ([192.131.102.5]:56044 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751044Ab1JJPTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:19:44 -0400
Date: Mon, 10 Oct 2011 11:19:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        Paul Walmsley <paul@pwsan.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <khilman@ti.com>, <b-cousson@ti.com>, <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
In-Reply-To: <20111010100507.GG6685@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.44L0.1110101117360.18069-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011, Felipe Balbi wrote:

> > > do we have sibling structures today? I dont think so.
> > 
> > no we don't.
> 
> Ok, here's a first shot at it:

In fact we do already have sibling lists.  They are maintained as part 
of the device_private structure.  What we are missing is a 
device_for_each_sibling() routine.  It could be added pretty easily; it 
would be similar to device_for_each_child().

Alan Stern

