Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab2LUMzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 07:55:51 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56067 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab2LUMzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 07:55:45 -0500
X-AuditID: 9c930179-b7becae000000e51-fd-50d45c4fc4a3
Date: Fri, 21 Dec 2012 21:55:43 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: remove redundant checks from _sort__sym_cmp
Message-ID: <20121221125543.GA2973@danjae>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
 <1356030701-16284-12-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1356030701-16284-12-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 02:11:20PM -0500, Sasha Levin wrote:
> We already check that sym_l and sum_r are non-NULLs, no need to
> do it twice.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
