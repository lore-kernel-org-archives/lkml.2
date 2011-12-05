Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab1LENhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:37:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59449 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311Ab1LENha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:37:30 -0500
X-Authority-Analysis: v=2.0 cv=dOUkaZlb c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=s3E4aK5dlEwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=4X31Rcb0lpIOy-eZmX4A:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: Suspend and resume on ASUS Laptops
From: Steven Rostedt <rostedt@goodmis.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20111205110336.GA13546@elf.ucw.cz>
References: <1322847694.30977.45.camel@frodo>
	 <Pine.LNX.4.44L0.1112021655580.1452-100000@iolanthe.rowland.org>
	 <20111205110336.GA13546@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Dec 2011 08:37:27 -0500
Message-ID: <1323092247.30977.76.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 12:03 +0100, Pavel Machek wrote:

> Is "USB legacy emulation" enabled in the BIOS? That caused problems
> before...

Yes it was set. I turned it off and removed the script but it still
failed to suspend. It locked up the exact same way with that option
enabled.

-- Steve


