Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab2AaCJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 21:09:03 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:47169 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab2AaCJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 21:09:01 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Damien Millescamps <damien.millescamps@6wind.com>
Subject: Re: [PATCH 24/29] sysctl: Replace root_list with links between sysctl_table_sets.
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
	<1327639925-12920-24-git-send-email-ebiederm@xmission.com>
	<20120130175112.GA20380@redhat.com>
Date: Mon, 30 Jan 2012 18:11:40 -0800
In-Reply-To: <20120130175112.GA20380@redhat.com> (Dave Jones's message of
	"Mon, 30 Jan 2012 12:51:13 -0500")
Message-ID: <m1d3a0fwo3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+VvpJcywOl9y8ojuTX/HuH3Fd5pM4/Ma4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> On Thu, Jan 26, 2012 at 08:52:00PM -0800, Eric W. Biederman wrote:
>
>  > +	memset(set, sizeof(*set), 0);
>
> checkpatch should warn you about this mistake.

Is there a way to tie checkpatch into git.  Perhaps into git commit?

Having something that would catch this before I embarrassed myself
certainly sounds nice.  However my overall impression of checkpatch
is that it catches newbie mistakes so unless it is trivial to run
checkpatch I don't expect I will run it because I don't expect to
tell me anything useful.

Eric
