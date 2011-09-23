Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab1IWXTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:19:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47198 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab1IWXTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:19:47 -0400
Message-ID: <4E7D1409.1010802@zytor.com>
Date: Fri, 23 Sep 2011 16:19:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel.org status
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

As you know, we've been working very hard on building a new kernel.org
infrastructure from the ground up.  This new infrastructure will no
longer have shell access to the git repositories; instead we will be
running git using the gitolite web glue.

Gitolite uses ssh keys to push into it, so we will start sending out new
ssh credentials to the active developers who had kernel.org accounts
before - please contact me or John so we can establish secure
communications (ideally through gpg keys).

One disadvantage of moving away from shell access is that gitolite has
very limited on-server scripting - so for those of you using git hooks
on kernel.org, you'll need to investigate how scripting works in
gitolite before this will be functional. We are planning to get the
first trees up and running early next week with broader access happening
in early October.

We will be bringing up additional developer services later, as resources
permit and we can do so securely.

We understand that the kernel.org outage has inconvenienced each of
you as well as the larger Linux community.  And, adjusting to the
new tools will take some additional time and hassle.  We apologize for
that.  But I want to assure you that getting the kernel.org
development machines back up is the highest priority of kernel.org.

Sincerely,

	-hpa
