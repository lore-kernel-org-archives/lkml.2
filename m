Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab2DDQH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 12:07:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756620Ab2DDQH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 12:07:56 -0400
Date: Wed, 4 Apr 2012 11:27:27 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org
Subject: RCU related performance regression in 3.3
Message-ID: <20120404152726.GB16299@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

We've had a few reports of some boot slowdowns with the 3.3 rebase we
did in Fedora 16.  One of our users volunteered to bisect a vanilla
kernel and wound up at "rcu: Permit dyntick-idle with callbacks pending
(commit 7cb924990)".  You can find more details in the bug [1], but it's
been reported on both physical hardware and in virtual machines.

Have you seen anything like this in your testing?  Given the user used a
vanilla 3.3 kernel, I'm wondering if there is a targetted fix that might
be backported.  If so, it would be good to get that headed to the 3.3.y
stable tree.

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=806548
