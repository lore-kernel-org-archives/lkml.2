Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451Ab1DNRbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:31:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35812 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756804Ab1DNRbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:31:38 -0400
Date: Thu, 14 Apr 2011 13:31:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tatyana Brokhman <tlinder@codeaurora.org>
cc: gregkh@suse.de, <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        <balbi@ti.com>,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH v3 2/5] uas: MS UAS Gadget driver - Infrastructure
In-Reply-To: <1302788176-27972-1-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1104141328390.2487-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011, Tatyana Brokhman wrote:

> This patch implements the infrastructure for the UAS gadget driver.
> The UAS gadget driver registers as a second configuration of the MS
> gadet driver.
> 
> A new module parameter was added to the mass_storage module:
> bool use_uasp. (default = 0)
> If this parameter is set to true, the mass_storage module will register
> with the UAS configuration as the devices first configuration and
> operate according to the UAS protocol.

As I understand it, drives typically have only one configuration and
one interface.  They implement Bulk-Only Transport on altsetting 0 and 
UAS on altsetting 1.

On the other hand, I don't think there's anything that says you _have_ 
to do it that way...

Alan Stern

