Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab2CTBDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 21:03:34 -0400
Received: from mail.vyatta.com ([76.74.103.46]:49127 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab2CTBDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 21:03:32 -0400
Date: Mon, 19 Mar 2012 18:03:28 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2 3.3.0
Message-ID: <20120319180328.39c8c6ea@nehalam.linuxnetplumber.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Sabre toothed Squirrel is released, and this means it is time for another
version of iproute2 (Maniac Moose??)

The main new features are:
  * Updated qdisc parameters in sfq and red
  * Netem extensions for shaping 
  * L2TP tunnelling
  * Lots of manual page corrections

Source:
  http://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-3.3.0.tar.gz

Repository:
  git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git

This version is signed with my GPG public key

Report problems (or enhancements) to the netdev@vger.kernel.org mailing list.

---
Andreas Henriksson (1):
      iproute: fix tc -iec display of Mibit rates

Anton Danilov (1):
      csum action, fix typo

Eric Dumazet (8):
      red: Add adaptative algo
      red: fix adaptive spelling
      sfq: add optional RED on top of SFQ
      choke: support TCA_CHOKE_MAX_P
      gred: support TCA_GRED_MAX_P attribute
      tc-red: update man page
      tc-sfq: update man page
      ss: should support CONFIG_INET_UDP_DIAG=n kernels

Florian Westphal (1):
      ip: xfrm: report nat-t/encapsulation portmapping updates

Greg Rose (1):
      iproute2: Add VF spoofchk command description to ip-link.8 man page

Hagen Paul Pfeifer (2):
      utils: add s32 parser
      tc: netem rate shaping and cell extension

Kenyon Ralph (1):
      Update ip address manual page

Masatake YAMATO (1):
      using NLM_F_DUMP flag constant in libnetlink.c

Matt Tierney (1):
      ss: Close file descriptors in tcp_show_netlink.

Pavel Emelyanov (1):
      iproute: Dump unix sockets via netlink

Petr Sabata (1):
      iproute2: tc - mqprio formatted print fix

Stephen Hemminger (23):
      iplt2p: remove unused libnl headers
      Fix man page whatis entry errors
      Update to kernel v3.3 headers
      Update to 3.3 headers (with inet_diag fix)
      netem: add rate extension to man page
      ip: make 'ip l' be 'ip link'
      Merge branch 'master' of nehalam:src/iproute2
      Fix unix socket diagnostic build
      Add cast to rta_getattr_str
      red: add missing include math.h
      Don't put configure files in /tmp
      dhcp-client-script: don't use /tmp
      ss: simplify code
      arpd: allow configuring polling interval
      ipaddress: cleanup code for link stats64
      Keep cscope around after make clean
      iproute: allow changing gretap parameters
      Fix ip-monitor manual page what-is entry
      update to 3.3-rc7 kernel headers
      Fix rta_getattr_u32 wrapper and add getattr_u8
      gre: allow 0 as a legal key value
      ip: allow set and display of link mode parameter
      v3.3.0

Tony Zelenoff (2):
      Modify neighbour proxy show
      Adjust man page for new functionality

Vijay Subramanian (4):
      netem: Add missing '}' in man page
      netem: Fail cleanly if user input is wrong
      netem: Fix up grammatical errors in man page
      netem: Fix 'reorder' section of man page

Yegor Yefremov (1):
      iproute2: cleanup dependencies

nick black (1):
      Update ip manpage

