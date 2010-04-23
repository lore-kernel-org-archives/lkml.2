Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab0DWLYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 07:24:37 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:48500 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab0DWLYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 07:24:35 -0400
Message-ID: <4BD18349.3020405@ru.mvista.com>
Date: Fri, 23 Apr 2010 15:23:53 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB fixes for 2.6.34-git
References: <20100422222610.GA3187@kroah.com>
In-Reply-To: <20100422222610.GA3187@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Greg KH wrote:

> Here are a number of USB bugfixes and new device ids for your 2.6.34-git
> tree.
>
> Nothing really huge, just a bunch of needed fixes for reported problems.
>
> Please pull from:
> 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/
>
> All of these patches have been in the linux-next and mm trees.
>
> The full patches will be sent to the linux-usb mailing list, if anyone
> wants to see them.
>   

   How about this series [1] of 11 MUSB fixes?

[1] http://marc.info/?l=linux-usb&m=126951575000396

WBR, Sergei

