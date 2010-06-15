Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab0FOHeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:34:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab0FOHeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:34:24 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: avi@redhat.com, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: TSC cleanups, fixes, documentation for KVM
Date: Mon, 14 Jun 2010 21:34:02 -1000
Message-Id: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an attempt to cleanup and plug some of the many existing holes
with TSC and as a direct result, kvmclock.  It is not a perfect attempt;
no trap and emulate is yet done for TSC in cases in which it can not be
perfectly virtualized.  In particular, on platforms with unstable /
buggy TSCs, it is not possible to even get a perfectly synchronized TSC.
TSC virtualization should be much improved and many bugs with suspend,
cpufreq as well as general synchronization errors will be eliminated.

