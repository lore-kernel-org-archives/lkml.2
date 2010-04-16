Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab0DPOe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:34:29 -0400
Received: from tex.lwn.net ([70.33.254.29]:52794 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758488Ab0DPOe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:34:28 -0400
Date: Fri, 16 Apr 2010 08:35:08 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>, "Intel OTC" <joel.clark@intel.com>,
       <andrew.chih.howe.khor@intel.com>
Subject: Re: [PATCH]Add device drivers (GbE, Packet Hub) for Topcliff
Message-ID: <20100416083508.64199657@tpl.lwn.net>
In-Reply-To: <000b01cadd4c$e2f94380$66f8800a@maildom.okisemi.com>
References: <000b01cadd4c$e2f94380$66f8800a@maildom.okisemi.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Apr 2010 19:09:04 +0900
"Masayuki Ohtake" <masa-korg@dsn.okisemi.com> wrote:

> I developed the device drivers for Linux kernel 2.6.33-1.
> This time, I added the following drivers
>   - GbE device
>   - Packet HUB device
> 
> Would you check them?

Thanks for making your code available.  May I suggest, though, that you
will get a much better response if you post the patches directly to the
mailing list?  That is how our process works; it is simply harder to
review code if you have to do digging through web sites to find it.

Networking-specific patches should be posted to the netdev list as well.

More information on how to post code for review can be found in the
kernel source tree:

	Documentation/HOWTO
	Documentation/development-process

Thanks,

jon
