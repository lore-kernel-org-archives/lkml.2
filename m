Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab0LWWKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 17:10:24 -0500
Received: from xenotime.net ([72.52.115.56]:60135 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751922Ab0LWWKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 17:10:20 -0500
Date: Thu, 23 Dec 2010 14:10:18 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: eric.valette@free.fr
Cc: lud <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.37-rc7: no more shutdown on DELL E6400
Message-Id: <20101223141018.e56e1a0d.rdunlap@xenotime.net>
In-Reply-To: <4D13C7E8.4020007@free.fr>
References: <4D131C9A.4020503@Free.fr>
	<20101223140226.04479f6a.rdunlap@xenotime.net>
	<4D13C7E8.4020007@free.fr>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Dec 2010 23:06:32 +0100 Eric Valette wrote:

> On 23/12/2010 23:02, Randy Dunlap wrote:
> > [add linux-usb list]
> 
> Note that after making
> 	make O=buildir mrproper; make mproper and rebuilding
> 
> I still have the hang after the "Will now halt", but no more the usb 
> message.

OK, thanks for the info.

Can you update  https://bugzilla.kernel.org/show_bug.cgi?id=25522

to include kernel log messages when you try to shutdown, please?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
