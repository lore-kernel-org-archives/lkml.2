Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051Ab2CBTAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 14:00:07 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54102 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab2CBTAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 14:00:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dsahern@gmail.com designates 10.68.217.65 as permitted sender) smtp.mail=dsahern@gmail.com; dkim=pass header.i=dsahern@gmail.com
Message-ID: <4F5118B1.5070406@gmail.com>
Date: Fri, 02 Mar 2012 12:00:01 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
Subject: perf_guest default bug
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to my last email, this patch is not in urgent trees or Linus' 
yet the problem exists in Linus' tree:
https://lkml.org/lkml/2012/2/17/82

$ /tmp/pbuild/perf record -a  -- sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.319 MB perf.data (~13935 samples) ]
Segmentation fault

Root cause is the perf_guest setting.

$ /tmp/pbuild/perf --version
perf version 3.3.rc5.60.g203738

David
