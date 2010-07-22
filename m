Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab0GVTza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 15:55:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22012 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab0GVTz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 15:55:26 -0400
Date: Thu, 22 Jul 2010 12:53:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: pavan_savoy@ti.com
Cc: gregkh@suse.de, alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, pavan_savoy@sify.com
Subject: Re: [PATCH 0/3] drivers:staging:ti-st: patches
Message-Id: <20100722125348.e4cd696f.randy.dunlap@oracle.com>
In-Reply-To: <1279794727-7669-1-git-send-email-pavan_savoy@ti.com>
References: <1279794727-7669-1-git-send-email-pavan_savoy@ti.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C48A21C.00D4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jul 2010 05:32:04 -0500 pavan_savoy@ti.com wrote:

> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> The following patches cleanup bit of a mess and also adds functionality to protocol drivers.
> with the 3rd patch now providing context to even the protocol drivers, the single device limit
> or support for multiple devices would be easier to implement.
> 
> These patches depend on the previously submitted
> 0001-drivers-staging-ti-st-make-use-of-linux-err-codes.patch
> commit d39d49b393d94f4137cee4f64526a4695352f183
> 
> Pavan Savoy (3):
>   drivers:staging:ti-st: smarten, reduce logs
>   drivers:staging:ti-st: cleanup code comments
>   drivers:staging:ti-st: give proto drivers context
> 
>  drivers/staging/ti-st/bt_drv.c  |   23 +++++---
>  drivers/staging/ti-st/st.h      |   52 +++++++++--------
>  drivers/staging/ti-st/st_core.c |  118 +++++++++++++++++++--------------------
>  drivers/staging/ti-st/st_core.h |   74 +++++++++++++++++--------
>  drivers/staging/ti-st/st_kim.c  |   73 ++++++++++++++----------
>  drivers/staging/ti-st/st_kim.h  |   77 ++++++++++++++++---------
>  drivers/staging/ti-st/st_ll.c   |    4 +-
>  drivers/staging/ti-st/st_ll.h   |    9 +++-
>  8 files changed, 255 insertions(+), 175 deletions(-)

Hi,

I have reported this error a few times.  Where is the patch for it??

ERROR: "st_get_plat_device" [drivers/staging/ti-st/st_drv.ko] undefined!


thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
