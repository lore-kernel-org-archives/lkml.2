Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab1DBMxL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 08:53:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64180 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab1DBMxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 08:53:10 -0400
Message-ID: <4D971BD7.5040203@ru.mvista.com>
Date: Sat, 02 Apr 2011 16:51:35 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: lkml <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>,
        lud <linux-usb@vger.kernel.org>, gregkh <greg@kroah.com>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] usb/serial: fix function args warnings, dropping *filp
References: <20110401180413.cb6e35fa.rdunlap@xenotime.net>
In-Reply-To: <20110401180413.cb6e35fa.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02-04-2011 5:04, Randy Dunlap wrote:

> From: Randy Dunlap<randy.dunlap@oracle.com>

> Fix build warnings caused by removal of *filp arg in
> struct usb_serial_driver.
> These changes were missed somehow in commits
> 00a0d0d65b61241a718d0aee96f46b9a2d93bf26 and
> 60b33c133ca0b7c0b6072c87234b63fee6e80558.

    How about also specifying the commit summaries for the human readers?

> drivers/usb/serial/mct_u232.c:159: warning: initialization from incompatible pointer type
> drivers/usb/serial/opticon.c:627: warning: initialization from incompatible pointer type

> Signed-off-by: Randy Dunlap<randy.dunlap@oracle.com>
> Cc: Alan Cox<alan@linux.intel.com>

WBR, Sergei
