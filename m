Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab2HaMVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 08:21:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60707 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab2HaMVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 08:21:15 -0400
Message-ID: <5040AAAE.30501@gmail.com>
Date: Fri, 31 Aug 2012 14:14:38 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        torvalds@linux-foundation.org
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: 3.6rc-3 doesn't compile um arch
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to compile the latest kernel for arch um, using the latest 
Linus's tree, but it doesn't compile due to the commit:

um: pass siginfo to the guest process.

I think the fix is trivial. At line 117 of os-Linux/time.c you find
this line:

   alarm_handler(SIGVTALRM, NULL);

but it should be:

   alarm_handler(SIGVTALRM, NULL, NULL);

Is it already fixed?

Marco
