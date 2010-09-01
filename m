Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0IAQIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 12:08:22 -0400
Received: from xenotime.net ([72.52.115.56]:59558 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754546Ab0IAQIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 12:08:21 -0400
Date: Wed, 1 Sep 2010 09:08:15 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: gene heskett <gheskett@wdtv.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: building 2.6.36-rc3, bails out at building modules stage 2
Message-Id: <20100901090815.dfed566a.rdunlap@xenotime.net>
In-Reply-To: <201009011200.11264.gheskett@wdtv.com>
References: <201009011200.11264.gheskett@wdtv.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Sep 2010 12:00:10 -0400 gene heskett wrote:

> Greetings all;
> 
> Using my usual build script, I got a bailout at the end:
> 
>   Building modules, stage 2.
>   MODPOST 869 modules
> ERROR: "st_get_plat_device" [drivers/staging/ti-st/st_drv.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> And I don't recognize that driver, but I don't believe I need it, so I'll 
> try to stop the building of it.

There's a patch for it, but GregKH hasn't merged it yet.
Just disable it.  You don't need it.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
