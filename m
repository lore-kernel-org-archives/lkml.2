Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191Ab1INUTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:19:15 -0400
Received: from gherkin.frus.com ([192.158.254.49]:56497 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933142Ab1INUTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:19:14 -0400
Date: Wed, 14 Sep 2011 15:19:12 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Subject: stupid git question
Message-ID: <20110914201912.GA29635@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject says a mouthful, but I digress...

Pointed "git" at Linus' github.com repository to pull the "-rc6"
changes (git pull <repo_url>).  Seems to have worked, except I received
no updated tags: the latest tag in my local repo copy is "v3.1-rc4".

Is this an expected consequence of doing the initial clone operation
from one repo, and then pulling updates from another that, in theory, is
identical to the first?  If so, is there an officially sanctioned method
of switching repositories that doesn't require blowing away the local
copy and doing another "git clone"?

Thanks.

--Bob
