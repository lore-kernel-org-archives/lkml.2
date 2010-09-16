Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab0IPAUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 20:20:14 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:38307 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751800Ab0IPAUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 20:20:13 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+f4+RZFkqfQ0iLyg7fimhRdT1m7lU0ZE5WP4CWE3
	S6pnd40epcyI2g
Message-ID: <4C9162BA.6000307@gmx.de>
Date: Thu, 16 Sep 2010 02:20:10 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] viafb security fix
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull a viafb security fix from:

   git://github.com/schandinat/linux-2.6.git 2.6.36-fixes

It contains a single patch to initialize the memory before it is copied to 
userspace. As this issue could be a security flaw it would be good to have this 
patch in the next release.


Thanks,

Florian Tobias Schandinat


Dan Rosenberg (1):
       drivers/video/via/ioctl.c: prevent reading uninitialized stack memory

  drivers/video/via/ioctl.c |    2 ++
  1 files changed, 2 insertions(+), 0 deletions(-)
