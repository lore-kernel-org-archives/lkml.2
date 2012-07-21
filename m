Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab2GUVvJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 17:51:09 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:50947 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707Ab2GUVvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 17:51:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 0/5] PM / shmobile: Specify PM domain and device latency information directly
Date: Sat, 21 Jul 2012 23:49:17 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207212349.18294.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The following patchset is on top of the previous one at:

https://lkml.org/lkml/2012/7/16/399

Generally speaking, it adds code for the direct specification of various
PM domain and device latencies used by PM QoS to the SH7372 SoC and
Mackerel board and suggests a mechanism for reading that information from
device trees.

Thanks,
Rafael
