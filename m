Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1AQQy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 11:54:27 -0500
Received: from canuck.infradead.org ([134.117.69.58]:44072 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab1AQQy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 11:54:26 -0500
Subject: Re: [RFC][PATCH 0/2 v1.0]sched: updating /proc/schedstat
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ciju Rajan K <ciju@linux.vnet.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <4D341ECD.3020503@linux.vnet.ibm.com>
References: <4D341ECD.3020503@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 17 Jan 2011 17:54:49 +0100
Message-ID: <1295283289.30950.172.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 16:19 +0530, Ciju Rajan K wrote:
> Hi All,
> 
> Here is the first version of the patch set, which updates
> the /proc/schedstat statistics. Please review the patches and let me
> know your thoughts.

Whats the impact on existing userspace, does the change warrant the
effort of changing the userspace tools?

Also, attachment fail.
