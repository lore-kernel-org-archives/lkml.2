Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab2IKNvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:51:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab2IKNva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:51:30 -0400
Date: Tue, 11 Sep 2012 15:50:50 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: eranian@google.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] perf tool: Allow wildcard in PMU name
Message-ID: <20120911135050.GB3800@krava.brq.redhat.com>
References: <1347263631-23175-1-git-send-email-zheng.z.yan@intel.com>
 <1347263631-23175-4-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347263631-23175-4-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 03:53:51PM +0800, Yan, Zheng wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> Allow wildcard in PMU name, so we can measure events on all
> uncore boxes of same type. For example:
> 
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>

example is missing ;)

jirka
