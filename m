Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab2CWOnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 10:43:14 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:52575 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab2CWOnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 10:43:13 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/2] tools: Add a toplevel Makefile
Date: Fri, 23 Mar 2012 15:43:05 +0100
Message-Id: <1332513788-9726-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi all,

here's a refreshed version from yesterday incorporating all comments and
suggestions along with a third patch that adds a 'help' target as the
default one causing the following below. Btw, Arnaldo, could you please
pick those up if there are no complaints since the first patch touches
perf and I don't have a clear idea who else to send it to anyway :).

Thanks.

$ make
Possible targets:

  cpupower   - a tool for all things x86 CPU power
  firewire   - the userspace part of nosy, an IEEE-1394 traffic sniffer
  lguest     - a minimal 32-bit x86 hypervisor
  perf       - Linux performance measurements tool
  slub       - slabs reporting tool
  turbostat  - Intel CPU idle stats and freq reporting tool
  usb        - USB testing tools
  virtio     - vhost test module
  x86_energy_perf_policy - Intel energy policy tool

Cleaning targets:

  all of the above with the "_clean" string appended cleans
    the respective build directory.
  clean: a summary clean target to clean _all_ folders


Changelog:

* v1:

this is a refresh and carve-out of an old patchset. It adds a toplevel
Makefile to tools/ so that one can build the tool of her/his liking by
simply doing

$ cd tools/
$ make <toolname>

By default, we build perf. There's also a scripts/Makefile.lib now which
should contain all make-related generic stuff which can be used by all
tools' build process after including this file.

</Changelog>

Any comments/suggestions are welcome,
thanks.
