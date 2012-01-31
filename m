Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab2AaCNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 21:13:48 -0500
Received: from [206.117.179.246] ([206.117.179.246]:46209 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752788Ab2AaCNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 21:13:46 -0500
Message-ID: <1327976007.5730.8.camel@joe2Laptop>
Subject: Re: [PATCH 24/29] sysctl: Replace root_list with links between
 sysctl_table_sets.
From: Joe Perches <joe@perches.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Damien Millescamps <damien.millescamps@6wind.com>
Date: Mon, 30 Jan 2012 18:13:27 -0800
In-Reply-To: <m1d3a0fwo3.fsf@fess.ebiederm.org>
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
	 <1327639925-12920-24-git-send-email-ebiederm@xmission.com>
	 <20120130175112.GA20380@redhat.com> <m1d3a0fwo3.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 18:11 -0800, Eric W. Biederman wrote:
> Is there a way to tie checkpatch into git.  Perhaps into git commit?

$ git log --format=email -p -1 $commit | \
  ./scripts/checkpatch.pl -

or maybe a front-end script prior to git commit

$ git diff --stat -p <paths> | \
  ./scripts.checkpatch.pl -


