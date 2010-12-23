Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab0LWWCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 17:02:30 -0500
Received: from xenotime.net ([72.52.115.56]:44150 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751258Ab0LWWC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 17:02:29 -0500
Date: Thu, 23 Dec 2010 14:02:26 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Eric.Valette@Free.fr, lud <linux-usb@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.37-rc7: no more shutdown on DELL E6400
Message-Id: <20101223140226.04479f6a.rdunlap@xenotime.net>
In-Reply-To: <4D131C9A.4020503@Free.fr>
References: <4D131C9A.4020503@Free.fr>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[add linux-usb list]


On Thu, 23 Dec 2010 10:55:38 +0100 Eric Valette wrote:

> I have the following messages:
> 
> Will now halt
> hub:4-0:1.0: hub_port_status_failed (err 110)
> 
> repeated twice.
> 
> I did not attend the shutdown last evening and it was blocked there this 
> morning. Retested and found same error.
> 
> Will open a regression bug (never have got this since 2.6.33).
> 
> -- eric


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
