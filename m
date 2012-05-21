Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335Ab2EUVho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:37:44 -0400
Received: from mail.vyatta.com ([76.74.103.46]:50063 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759194Ab2EUVhn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:37:43 -0400
Date: Mon, 21 May 2012 14:37:40 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2 3.4.0
Message-ID: <20120521143740.2f6c0ecd@nehalam.linuxnetplumber.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To go with kernel release of 3.4 here is the update to
iproute2. There wasn't a lot new features in this release, mostly
manual pages and cleanups.

Source:
  http://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-3.4.0.tar.gz

Repository:
  git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git

Changes:

Andreas Henriksson (1):
      iproute2: trivial fix of ip link syntax in manpage

Chris Elston (1):
      iproute2: allow IPv6 addresses for l2tp local and remote parameters

Christoph J. Thompson (4):
      iproute2 - Don't hardcode the path to config files
      iproute2 - Split up cflags
      iproute2 - Split up manual page installation
      iproute2 - Fix up and simplify variables pointing to install directories

Eric Dumazet (1):
      Fix ss if INET_DIAG not enabled in kernel

Florian Westphal (1):
      tc: man: choke counts packets, not bytes

James Chapman (1):
      iproute2: add ip-l2tp man page

Jorge Boncompte [DTI2] (1):
      iproute: show metrics as an unsigned value

João Valverde (1):
      ipl2tp: allow setting session interface name

Rose, Gregory V (1):
      iproute2: Add netlink attribute to filter dump requests

Shan Wei (1):
      ss: use new INET_DIAG_SKMEMINFO option to get more memory information for tcp socket

Stephen Hemminger (6):
      Add ability to set link state with ip
      Make link mode case independent
      Convert to use rta_getattr_ functions
      Merge in 3.3-rc2 kernel headers
      Revert "iproute2: allow IPv6 addresses for l2tp local and remote parameters"
      v3.4.0

Vijay Subramanian (1):
      Update man8 Makefile

