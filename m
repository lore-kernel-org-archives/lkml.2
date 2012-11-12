Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab2KLVwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:52:09 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57335 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2KLVwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:52:07 -0500
MIME-Version: 1.0
Date: Tue, 13 Nov 2012 07:52:06 +1000
Message-ID: <CAPM=9twSHBet=vDY9q4BXKv7ZUPR-eme75tOzxrWf6Bsp4MMkw@mail.gmail.com>
Subject: removal of sysfs wext extension broke on F16
From: Dave Airlie <airlied@gmail.com>
To: johannes.berg@intel.com, John Linville <linville@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

https://bugzilla.redhat.com/show_bug.cgi?id=875328

blamed for breaking wireless.
https://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=35b2a113cb0298d4f9a1263338b456094a414057

apparantly the initscripts used the sysfs directory existance as a
check, so maybe either back this out or bring back just the subdirs.

Dave.
