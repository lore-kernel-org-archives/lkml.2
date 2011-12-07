Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1LGBcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 20:32:11 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41655 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab1LGBcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 20:32:09 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4EDEC207.90403@jp.fujitsu.com>
Date: Wed, 07 Dec 2011 10:31:51 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-btrfs@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 0/3] perf: parser fix for btrfs tracepoints
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After playing with v3.2-rc4, I found that the perf command failed to
parse record contain data from (relatively new) btrfs tracepoints.

This patch set will improve parser code of perf command and allow
it to handle these data from btrfs tracepoints well.

Thanks,
H.Seto

Hidetoshi Seto (3):
      perf: parse greater/less than or equal
      perf: allow processing single op args
      perf: allow typecast for signed value

 tools/perf/util/trace-event-parse.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

