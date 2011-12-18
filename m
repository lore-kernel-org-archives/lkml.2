Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab1LRXVs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 18:21:48 -0500
Received: from mail.snarked.org ([67.43.172.250]:29921 "EHLO mail.snarked.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab1LRXVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 18:21:44 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Dec 2011 18:21:44 EST
X-Envelope-From: <newsserv> (mail.snarked.org)
To: linux-kernel@vger.kernel.org
From: "D. Stussy" <spam+newsgroups@bde-arc.ampr.org>
Newsgroups: linux.kernel
Subject: [Additional]: Kernel non-fatal(?) bug - IPsec - Holding atomic when calling scheduler.
Date: Sun, 18 Dec 2011 15:14:37 -0800
Message-ID: <jcls4q$518$1@snarked.org>
References: <i8PHj-7xK-5@gated-at.bofh.it>
Reply-To: "D. Stussy" <replies+newsgroups@kd6lvw.ampr.org>
X-No-Archive: Yes
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1478
X-Priority: 3
X-Newsreader: Microsoft Outlook Express 6.00.2800.1478
X-MSMail-Priority: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even a simple policy set like this triggers the bug:

# setkey -c <<EOF
> spdadd localhost localhost any -P in none;
> spdadd localhost localhost any -P out none;
> EOF

Obviously, turning off IPsec on the loopback address is a given, yet
despite declaring "none" for the policy (as opposed to "ipsec" with a real
policy) is enough to trigger the bug.

Is anyone else experiencing this bug?


