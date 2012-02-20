Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab2BTHcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 02:32:39 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34437 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2BTHci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 02:32:38 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gcoady.lk@gmail.com designates 10.68.190.226 as permitted sender) smtp.mail=gcoady.lk@gmail.com; dkim=pass header.i=gcoady.lk@gmail.com
From: Grant Coady <gcoady.lk@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: compile warnings, linux-3.2.6a/arch/x86/include/asm/uaccess_32.h, was Re: Linux 3.2.6
Date: Mon, 20 Feb 2012 18:32:30 +1100
Organization: scattered
Message-ID: <5nt3k7hnqp0cpctcalotfordt752jvqp3c@4ax.com>
References: <20120213192545.GA28291@kroah.com> <h561k71mg76rebd4m46l25791ilkcr8n0r@4ax.com> <20120219152108.GB15136@kroah.com>
In-Reply-To: <20120219152108.GB15136@kroah.com>
X-Mailer: Forte Agent 6.00/32.1186
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Feb 2012 07:21:08 -0800, you wrote:

>On Sun, Feb 19, 2012 at 05:50:45PM +1100, Grant Coady wrote:
>> On Mon, 13 Feb 2012 11:25:45 -0800, you wrote:
>> 
>> >I'm announcing the release of the 3.2.6 kernel.
>> >
>> >All users of the 3.2 kernel series must upgrade.
>> 
>> I'm getting:
>> ...
>>   CC      drivers/net/Space.o
>
><snip>
>
>Does this also happen in 3.2.5?  Can you narrow it down to a specific
>patch?

Yes, and all the way back to 3.2.  No idea what brought it on, 3.2.6 
was a skip from 2.6.38.7 for me so I cannot easily tell when it came in.

Cheers,
Grant.
