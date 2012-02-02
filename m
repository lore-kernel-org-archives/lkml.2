Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab2BBDZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 22:25:12 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:40345 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab2BBDZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 22:25:10 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [Review][PATCH][0/4] sysctl bitty fixes
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
Date: Wed, 01 Feb 2012 19:27:51 -0800
In-Reply-To: <m1pqe5ah3z.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Thu, 26 Jan 2012 20:45:20 -0800")
Message-ID: <m139atx6bs.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19tiXRzzs1iqopllDM70CFOI4saBZDGYVs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After digging through Lucian comments here are my incremental fixes
to address them.

This code is also available at:
kernel.org/pub/scm/linux/kernel/git/ebiederm/sysctl.git

Eric W. Biederman (4):
      sysctl: An easier to read version of find_subdir
      sysctl: Correct error return from get_subdir
      sysctl: Comments to make the code clearer.
      sysctl: Don't call sysctl_follow_link unless we are a link.

 fs/proc/proc_sysctl.c |   51 +++++++++++++++++++++++++++++++++---------------
 1 files changed, 35 insertions(+), 16 deletions(-)
