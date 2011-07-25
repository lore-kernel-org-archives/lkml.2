Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab1GYN0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:26:05 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59302 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab1GYN0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:26:01 -0400
Date: Mon, 25 Jul 2011 09:25:53 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf:  Add drop monitor script
Message-ID: <20110725132553.GA17003@hmsreliant.think-freely.org>
References: <1309801217-22450-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309801217-22450-1-git-send-email-nhorman@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -0.7 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 01:40:17PM -0400, Neil Horman wrote:
> A while back I created the dropmonitor protocol, which allowed users to get
> reports of dropped frames communicated to them via a netlink socket.  While
> useful, several people have now asked that I integrate the ability to do drop
> monitoring with perf, so they don't have to run additional tools.  This patch
> adds a drop monitor script to the perf suite, and provides the same output that
> the netlink socket does.
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Ping again, Acme, any thoughts?
Neil

> 
