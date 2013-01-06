Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab3AFATD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 19:19:03 -0500
Received: from zfrontend1.aha.ru ([195.2.83.147]:43997 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755918Ab3AFATB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 19:19:01 -0500
From: "werner" <w.landgraf@ru.ru>
Subject: Linux 3.8-rc1: compiling problem in perf-event-p6.o
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Sat, 05 Jan 2013 20:18:56 -0400
Message-ID: <web-832791539@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The problem continues with 3.8-rc

This is grave, no vmlinuz is produced.


wl

   CC      arch/x86/kernel/cpu/perf_event.o
   CC      arch/x86/kernel/cpu/perf_event_amd.o
   CC      arch/x86/kernel/cpu/perf_event_p6.o
arch/x86/kernel/cpu/perf_event_p6.c:22: error: 
p6_hw_cache_event_ids causes a section type conflict
make[3]: [arch/x86/kernel/cpu/perf_event_p6.o] Error 1 
(ignored)
   CC      arch/x86/kernel/cpu/perf_event_knc.o
   CC      arch/x86/kernel/cpu/perf_event_p4.o
   CC      arch/x86/kernel/cpu/perf_event_intel_lbr.o

================================================
There ocurs a compiling error in perf-event-p6.o , any 
regression, unfortunately I lost the compiling list but I 
think it was any incompatibility / redefinition with 
something else, pls check and correct that, if not already 
done
W.Landgraf
---
---
Professional hosting for everyone - http://www.host.ru
