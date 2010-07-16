Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808Ab0GPSSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 14:18:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758789Ab0GPSSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 14:18:13 -0400
Date: Fri, 16 Jul 2010 12:18:02 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: linux-kbuild@vger.kernel.org
Cc: <nico-linuxsetlocalversion@schottelius.org>, linux-kernel@vger.kernel.org,
        zaitcev@redhat.com
Subject: I did a git pull and a plus appeared
Message-ID: <20100716121802.65fdfa24@lembas.zaitcev.lan>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All:

I have a tree that existed for a few years (a clone of Linus' tree).
Today I did a git pull in it, and a plus appeared in the built version.
E.g. after "make modules_install":

[root@niphredil linux-2.6-tip]# ls /lib/modules/
2.6.33.1-19.fc13.x86_64  2.6.34-rc6-tip                    2.6.35-rc1-tip
2.6.34-43.fc14.x86_64    2.6.35-0.36.rc4.git5.fc14.x86_64  2.6.35-rc5-tip+
[root@niphredil linux-2.6-tip]# 

How do I get rid of the plus? I have (had for a long time):

[zaitcev@niphredil linux-2.6-tip]$ grep LOCAL .config
CONFIG_LOCALVERSION="-tip"
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_X86_LOCAL_APIC=y
[zaitcev@niphredil linux-2.6-tip]$ 

Thanks,
-- Pete
