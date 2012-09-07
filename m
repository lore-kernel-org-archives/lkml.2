Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab2IGPkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:40:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59899 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab2IGPkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:40:40 -0400
Message-ID: <1347032431.18408.90.camel@twins>
Subject: Re: [PATCH 3/3] perf: remove jiffies_interval
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com, robert.richter@amd.com
Date: Fri, 07 Sep 2012 17:40:31 +0200
In-Reply-To: <1347028169-1983-4-git-send-email-eranian@google.com>
References: <1347028169-1983-1-git-send-email-eranian@google.com>
	 <1347028169-1983-4-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 16:29 +0200, Stephane Eranian wrote:
> Obsolete because superseded by hrtimer based
> multiplexing.

Not entirely, the jiffies_interval allows different PMUs to have
different rotation speeds. Your code doesn't allow this.

