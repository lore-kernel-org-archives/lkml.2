Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab2A3RvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:51:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab2A3RvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:51:19 -0500
Date: Mon, 30 Jan 2012 12:51:13 -0500
From: Dave Jones <davej@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Damien Millescamps <damien.millescamps@6wind.com>
Subject: Re: [PATCH 24/29] sysctl: Replace root_list with links between
 sysctl_table_sets.
Message-ID: <20120130175112.GA20380@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org,
	Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
	Damien Millescamps <damien.millescamps@6wind.com>
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
 <1327639925-12920-24-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327639925-12920-24-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 08:52:00PM -0800, Eric W. Biederman wrote:

 > +	memset(set, sizeof(*set), 0);

checkpatch should warn you about this mistake.

	Dave
