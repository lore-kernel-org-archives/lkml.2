Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab0HZUIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 16:08:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48840 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498Ab0HZUIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 16:08:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM QoS fixes for 2.6.36
Date: Thu, 26 Aug 2010 22:06:53 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        markgross@thegnar.org, Saravana Kannan <skannan@codeaurora.org>,
        "Dr. David Alan Gilbert" <linux@treblig.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008262206.53748.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull two PM QoS fixes for 2.6.36 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

They fix a kzalloc() call with swapped arguments and a kerneldoc comment
that doesn't match the code it describes any more after the last PM QoS
update.


 kernel/pm_qos_params.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

---------------

David Alan Gilbert (1):
      PM QoS: Fix kzalloc() parameters swapped in pm_qos_power_open()

Saravana Kannan (1):
      PM QoS: Fix inline documentation.

