Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab1C2BNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 21:13:11 -0400
Received: from mail.vyatta.com ([76.74.103.46]:43603 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab1C2BNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 21:13:09 -0400
Date: Mon, 28 Mar 2011 18:13:06 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: netdev@vger.kernel.org, bridge@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] bridge-utils 1.5
Message-ID: <20110328181306.2b1a117e@nehalam>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Bridge Utilities haven't been re-released in a very long time.
The only new feature is the introduction of hairpin mode.

Note: this is probably the last release of these utilities because
I am actively working on intergrating bridge utility into iproute2
using netlink.

Package download:
   http://sourceforge.net/projects/bridge/files/bridge/bridge-utils-1.5.tar.gz/download

Repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/bridge-utils.git

Information:
   http://www.linuxfoundation.org/collaborate/workgroups/networking/bridge

Report problems (or enhancements) to the netdev@vger.kernel.org mailing list.

Changelog:

Anton Danilov (1):
      show selected bridge

Fischer, Anna (1):
      bridge-utils: Add 'hairpin' port forwarding mode

Stephen Hemminger (8):
      don't install libbridge.a
      use proper version of install in doc/Makefile
      Check for fopen() failing
      Skip . and .. in foreach_bridge test
      Handle unknown attributes more gracefully
      bridge-utils 1.5
      update mailing address
      Update URL of git repository

