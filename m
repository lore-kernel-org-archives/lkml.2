Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045Ab0CPVe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:34:29 -0400
Received: from mail.windriver.com ([147.11.1.11]:34513 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146Ab0CPVeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:34:23 -0400
Message-ID: <4B9FF954.1010600@windriver.com>
Date: Tue, 16 Mar 2010 16:34:12 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: gregkh@suse.de, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>, Oliver Neukum <oliver@neukum.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] usb-serial: Use tty_port version of consoleinstead
 of the usb_serial_port version
References: <1268773546-12457-1-git-send-email-jason.wessel@windriver.com> <1268773546-12457-2-git-send-email-jason.wessel@windriver.com> <1268773546-12457-3-git-send-email-jason.wessel@windriver.com> <20100316212350.GC31739@kroah.com>
In-Reply-To: <20100316212350.GC31739@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Mar 2010 21:34:12.0004 (UTC) FILETIME=[6B32FE40:01CAC550]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 04:23 PM, Greg KH wrote:
> On Tue, Mar 16, 2010 at 04:05:43PM -0500, Jason Wessel wrote:
>   
>> Replace all instances of using the console variable in struct
>> usb_serial_port with the struct tty_port version.
>>     
>
> I've also already applied this one, right?
>   
Correct.  There is no change.

Jason.
