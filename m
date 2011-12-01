Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab1LAELe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 23:11:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60301 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab1LAELd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 23:11:33 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=pHgAmLnZu2cA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=LSr1gJj7AAAA:8 a=Qtdqo1-JAAAA:8 a=maL2J-n9Vxks1hFtfXIA:9 a=QEXdDO2ut3YA:10 a=IrBqwOtLvWUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Suspend and resume on ASUS Laptops
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Nov 2011 23:11:29 -0500
Message-ID: <1322712689.30977.11.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For Black Friday I bought myself a ASUS-U56E-RBL8 at Staples for a
decent price. I installed Linux on it but it would not suspend. It would
always hang with the hard drive light on, as well as other leds and the
power light.

Searching the web, I found this link:

http://thecodecentral.com/2011/01/18/fix-ubuntu-10-10-suspendhibernate-not-working-bug

That talks about adding a script found here:

http://ubuntuforums.org/showpost.php?p=10359462&postcount=47

I added the script and sure enough, my suspend and even resume now work.

Before using this script, I've tried this on latest Debian testing and
with the latest Linus kernel (as of last night), and it didn't work. But
with this script, it works there and also with Debian stable and 3.0.10
kernel. (I hate gnome3 and lack of gnome2 so I created a separate
partition to run Debian testing, but I'm back to Debian stable).

The reason I'm writing you is, can we fix this without needing this
script?  Is there a modification to pm-suspend, or something that can
handle these laptops?

It just seems crazy to have everyday users add this script.

Thanks,

-- Steve


