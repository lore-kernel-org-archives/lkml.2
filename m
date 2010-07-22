Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759539Ab0GVOWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 10:22:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33675 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758866Ab0GVOWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 10:22:38 -0400
Date: Thu, 22 Jul 2010 10:22:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
cc: linux-usb@vger.kernel.org, Adam Kropelin <akropel1@rochester.rr.com>,
        Xiaofan Chen <xiaofanc@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: core: Choose configuration with lowest bConfigurationValue
In-Reply-To: <ed7910dcd6f62c058938f30aceb0fa5cd7c3f385.1279807231.git.m.nazarewicz@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1007221020440.1725-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jul 2010, Michal Nazarewicz wrote:

> This patch removes code from usb_choose_configuration()
> responsible for ignoring the first USB device configuration if
> its first interface is RNDIS.  Instead,
> usb_choose_configuration() chooses configuration with lowest
> bConfigurationValue.  Linux' Ethernet gadget uses a lower
> bConfigurationValue for the second configuration which is
> a CDC configuration so this code should choose configuration
> that suits Linux better.

I don't like this idea.  Choosing configs is a sensitive topic, since 
it is highly visible to users.  It should be changed minimally, if at 
all.

Alan Stern

