Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab2A3LaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 06:30:17 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62124 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab2A3LaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 06:30:16 -0500
MIME-Version: 1.0
Date: Mon, 30 Jan 2012 11:30:15 +0000
Message-ID: <CAKaSfQBrw2pcC8nsNtyQc5bqevW2WX5ykHnReWMWQNc6b4ZUVA@mail.gmail.com>
Subject: status of Marvell SATA/SAS controller Drivers
From: Simon McNair <simonmcnair@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I've heard of ongoing problems with the drivers for the Marvell
Controllers (since 2.6.30 ?) , I have two units with Marvell chips (a
self build 10 bay sata hot-plug enclosure with Supermicro
AOC-SASLP-MV8 and a 5 bay Thecus 5200BPro). and I'd like to know if
there is a list of outstanding issues, if any, with the chips used.  I
believe these are:

self build :Marvell 6480
Thecus: Marvell Technology Group Ltd. MV88SX6081 8-port SATA II PCI-X
Controller (rev 09)

The problem that I have personally experienced was on (and before) the
12 December 2011 and (to my entirely untrained eye) consisted of one
of more of the drives posting unplug and plug messages.  I suspect
this later resulted in a degraded array and a resync.  I am not a
Linux expert so I don't know what else to include.

As an aside, are there any recommendations regarding sanitising
kernel/dmesg logs prior to posting as I have a copy of the logs which
contain the zgrep's of 'mvsas' and resultant errors and would be happy
to post them if desired.

The reason for this is that my Thecus (Linux 2.6.13N5200 #135 Mon May
24 17:46:32 CST 2010 i686 unknown) has gone out of support and I am
looking at installing Ubuntu server on it and I don't want to do this
is the controller issues are still present.  I've not noticed any
issues with the 2.6.13 kernel that the unit is on but the logs are
heavily sanitised by Thecus so I can't tell.  I am considering going
for the Ubuntu 10.04 LTS Server release but I don't know what, if any,
impact doing updates will have on the mvsas driver.

Thank you for your help and I'm sorry for the lack of information.

regards
Simon
