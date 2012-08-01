Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab2HAXF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 19:05:56 -0400
Received: from mail.vyatta.com ([76.74.103.46]:37935 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab2HAXFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 19:05:53 -0400
Date: Wed, 1 Aug 2012 16:05:50 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2 3.5.0
Message-ID: <20120801160550.344a66b1@nehalam.linuxnetplumber.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the trend of releasing before going on vacation, here is the
iproute2 release to go with last weeks 3.5.0 kernel release. The changes
were mainly adding support for the new queuing disciplines (codel etc)
and cleaning up the manual pages.


Source:
  http://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-3.5.0.tar.gz

Repository:
  git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git

Andreas Henriksson (1):
      iproute2: man page and /bin/ip disagree on del vs delete

Ben Hutchings (1):
      ss: Report MSS from internal TCP information

Bjarni Ingi Gislason (2):
      tc(8): Negative indent and missing "-" after an escape
      tc-drr(8): tab unquoted in a argument to a macro

Chris Elston (1):
      iproute2: allow IPv6 addresses for l2tp local and remote parameters

Eric Dumazet (3):
      tc_codel: Controlled Delay AQM
      fq_codel: Fair Queue Codel AQM
      ip: speedup ip link

Hiroaki SHIMODA (2):
      tc: u32: Fix icmp_code off.
      tc: u32: Fix firstfrag filter.

Jan Ceuleers (2):
      tc-codel: Fix typos in manpage
      Add reference to tc-codel(8) to the SEE ALSO section

Li Wei (6):
      tc: man: Fix incorrect parameter format in prio.
      tc: prio: Perform more strict check on priomap.
      tc: filter: validate filter priority in userspace.
      tc: man: add 'delete' command.
      tc: man: change man page and comment to confirm to code's behavior.
      tc-bfifo: man: Add parameter value range.

Stephen Hemminger (7):
      Update headers to 3.5 merge window
      Remove derived man pages
      Refactor ipaddr_list_or_flush
      Remove reference to multipath algorithms in usage
      man8: build cleanup
      Add bridge command
      v3.5.0

Vijay Subramanian (6):
      Update tc-netem manpage to add ecn capability
      tc-netem: Add support for ECN packet marking
      tc-codel: Add manpage
      tc-codel: Update usage text
      tc-fq_codel: Add manpage
      tc: Update manpage

