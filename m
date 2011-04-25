Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab1DYSfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 14:35:47 -0400
Received: from lucidpixels.com ([75.144.35.66]:35703 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758203Ab1DYSfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 14:35:46 -0400
Date: Mon, 25 Apr 2011 14:35:45 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: 2.6.38: rt2800usb: driver is crashing the kernel
In-Reply-To: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1104251432560.23304@p34.internal.lan>
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I notice periodic kernel crashes when using wireless.
Has anyone seen this using the rt2800usb driver?

When the host is on the LAN (supermicro+intel), there are zero crashes.
Since I don't have it in a location where I can use netdump over the 
LAN/wire, see the picture below for the kernel crash/OOPS on the console:

http://home.comcast.net/~jpiszcz/20110425/kernel_crash.jpg [1.2m]

Thoughts?

Justin.


