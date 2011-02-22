Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab1BVIhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:37:48 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:45745 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab1BVIhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:37:47 -0500
Date: Tue, 22 Feb 2011 14:08:06 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Ciju Rajan K <ciju@linux.vnet.ibm.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/2 v3.0]sched: updating /proc/schedstat
Message-ID: <20110222083805.GA26066@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <4D3F3595.4020607@linux.vnet.ibm.com>
 <4D5E6970.1000105@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5E6970.1000105@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 06:13:28PM +0530, Ciju Rajan K wrote:
> Hi All,
> 
> Here is the v3.0 of the patch set, which updates 
> /proc/schedstat statistics. Please review the patches
> and consider for inclusion.

I believe this documentation cleanup is good to go in. Hope you
have ensured that userspace can work smoothly with the bumped up
version.

Regards,
Bharata.
