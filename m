Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab0DICge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 22:36:34 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:3880 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935Ab0DICgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 22:36:32 -0400
Message-ID: <4BBE92AE.6090301@gmail.com>
Date: Fri, 09 Apr 2010 04:36:30 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100403 Lightning/1.0b2pre Shredder/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: 2.6.34-rc3-git8: Reported regressions 2.6.32 -> 2.6.33
References: <cjwJ7Pf9h0L.A.9pB.1DmvLB@chimera>
In-Reply-To: <cjwJ7Pf9h0L.A.9pB.1DmvLB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Apr 2010 02:36:30.0641 (UTC) FILETIME=[762B9A10:01CAD78D]
X-RecipientDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/10 00:54, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15699
> Subject		: rt2500usb driver cannot remain connected
> Submitter	:  <abcd@gentoo.org>
> Date		: 2010-04-05 19:30 (4 days old)
> Handled-By	: Ivo van Doorn <IvDoorn@gmail.com>
> 

This one ought to be fixed by commit 9e76ad2a27f592c1390248867391880c7efe78b3
in Linus' tree.

---
Gertjan.
