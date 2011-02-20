Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab1BTERv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 23:17:51 -0500
Received: from mx2.parallels.com ([64.131.90.16]:49802 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab1BTERu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 23:17:50 -0500
Message-ID: <4D6095E3.2040103@parallels.com>
Date: Sat, 19 Feb 2011 22:17:39 -0600
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>
Subject: Update to http://kernel.org/doc
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [99.24.57.198]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that I'm actually doing kernel development as my day job (containers
stuff for Parallels), I've taken some time to brush up the old kernel
documentation directory on kernel.org that I theoretically maintain.

It now includes:

1) Web versions of all the documentation I could find in the kernel
source tarball, put on the web where Google can find it.  (You can now
link to the help text for menuconfig symbol, or refer to the output of
"make htmldocs" via URL instead of telling people to build it themselves.)

2) Links to a bunch of standards documents applicable to the kernel.

3) Links to a bunch of other web pages containing kernel documentation
(including broken-up copies of all the OLS papers dating back to 2001).

4) Other stuff.

I'm not saying it's complete.  I'm just saying I exhumed it, gave it a
good scrub, applied the interocitor to the bolts on its' neck, and sent
it lurching towards the village...

Opinions?

Rob

P.S.  Yes I know I still need to index the 2010 Ottawa Linux Symposium
papers.  I got 2009 properly indexed, though.
