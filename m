Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068Ab2CBSsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 13:48:04 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38604 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758347Ab2CBSr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 13:47:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dsahern@gmail.com designates 10.68.225.164 as permitted sender) smtp.mail=dsahern@gmail.com; dkim=pass header.i=dsahern@gmail.com
Message-ID: <4F5115DA.5000001@gmail.com>
Date: Fri, 02 Mar 2012 11:47:54 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: no build option fails in kerneltip
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo:

I noticed this patch is not in Linus' tree or your perf-urgent (only 
your perf-core): https://lkml.org/lkml/2012/2/6/415

Yet, the problem is in Linus' tip:

$ /tmp/pbuild/perf record -a -BN -- sleep 1
Couldn't generating buildids. Use --no-buildid to profile anyway.
sleep: Terminated

$ /tmp/pbuild/perf --version
perf version 3.3.rc5.60.g203738

David
