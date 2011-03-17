Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab1CQRQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:16:58 -0400
Received: from mail.vyatta.com ([76.74.103.46]:36931 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab1CQRQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:16:55 -0400
Date: Thu, 17 Mar 2011 10:16:52 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute 2.6.38
Message-ID: <20110317101652.27e68348@nehalam>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to popular demand, there is an iproute2 release for 2.6.38 after all. 

This version of iproute2 utilities intended for use with 2.6.38 or
later kernel, but should be backward compatible with older releases.
New features are support for macvlan passthru and xfrm security context.

Source: (note old developer.osdl.org address works as well)
  http://devresources.linuxfoundation.org/dev/iproute2/download/iproute2-2.6.38.tar.bz2

Repository:
  git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git

For more info on iproute2 see:
  http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2

Report problems (or enhancements) to the netdev@vger.kernel.org mailing list.

Changelog:

Gerrit Renker (3):
      utils: get_jiffies always uses base=0
      iproute: fix unit conversion of rtt/rttvar/rto_min
      iproute: rename 'get_jiffies' since it uses msecs

Joy Latten (3):
      xfrm security context support
      xfrm security context support
      xfrm security context support

Nicolas Dichtel (1):
      iproute2: allow to specify truncation bits on auth algo

Sridhar Samudrala (1):
      macvlan/macvtap: support 'passthru' mode

Stephen Hemminger (2):
      Update to lasest kernel headers
      v2.6.38.1

Vlad Dogaru (1):
      iproute2: fix man page whitespace

