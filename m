Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab0EUVmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 17:42:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57149 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab0EUVme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 17:42:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [Regression] Negative time on Acer Ferrari One with current -git
Date: Fri, 21 May 2010 23:43:25 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005212343.25184.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Trying to boot current -git on Acer Ferrari One (64-bit), I get mount errors
for all filesystems telling me that "now = (null) is in the future" and when
run 'date' it says: "date: time <long negative number> is out of range".

Any ideas anyone?

Rafael
