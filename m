Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032428Ab2I1U7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:59:23 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57078 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964962Ab2I1U7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:59:20 -0400
Message-ID: <1348865957.14262.46.camel@joe-AO722>
Subject: Re: Probable false positive in checkpatch
From: Joe Perches <joe@perches.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andy Whitcroft <apw@canonical.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Date: Fri, 28 Sep 2012 13:59:17 -0700
In-Reply-To: <Pine.LNX.4.44L0.1209281546480.1164-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1209281546480.1164-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-28 at 15:50 -0400, Alan Stern wrote:
> Here's what I just got from checkpatch:
> 
> ERROR: space prohibited after that '-' (ctx:BxW)
> #22: FILE: drivers/usb/host/ehci-sched.c:1419:
> +                       start += (next - start + period - 1) & (- period);
>                                                                 ^
> This seems unlikely to be a real style violation.  Or if it is, maybe 
> it shouldn't be.  After all, "(0 - period)" would be okay.

2c: I think the recommendation is proper and correct.



