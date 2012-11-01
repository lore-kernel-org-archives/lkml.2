Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762268Ab2KAVJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 17:09:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35967 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758641Ab2KAVJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 17:09:49 -0400
Message-ID: <5092E51A.8040200@gmail.com>
Date: Thu, 01 Nov 2012 15:09:46 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: why is perf-report asking for objdump path?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ /tmp/pbuild/perf report -i perf.data --kallsyms kallsyms
Error:
Please install objdump for i686.
You can add it to PATH, set CROSS_COMPILE or override the default using 
--objdump.

And worse it refuses to run without it. If I was running the annotate 
command I could understand the request -- but this is the report path.

Furthermore objdump exists:

$ which objdump
/usr/bin/objdump

yes, the file was created on an i686 target, but I should be able to use 
the x86_64 host objdump if I were doing an annotate.

David
