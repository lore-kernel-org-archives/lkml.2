Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab1L3Xy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 18:54:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab1L3Xy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 18:54:27 -0500
Date: Fri, 30 Dec 2011 18:54:21 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: loading firmware while usermodehelper disabled.
Message-ID: <20111230235421.GA6054@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're getting a bunch of reports against Fedora 16
(still using 3.1) which look like some drivers are trying to
load firmware on resume from suspend, while usermodehelper
is disabled.

Here are some example traces:

https://bugzilla.redhat.com/show_bug.cgi?id=746411
https://bugzilla.redhat.com/show_bug.cgi?id=771002

This possibly sounds like the problem that caca9510ff4e5d842c0589110243d60927836222
was trying to fix, but that patch is present in the kernels
being reported.

any ideas ?

	Dave

