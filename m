Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab1EUI5D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 04:57:03 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52373 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab1EUI5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 04:57:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WOMdSqCAx0bHejneiCigXsBSZ0a0Y+lTfp38k7gpgAEF8iCxswstXKJ4MYGmg4KqMN
         eZ1MqgpcRw1httSrTb8Xj6XIcKKGZ2bBxHF6tOGW/xKH5bSTu9GOstkUYd7khYX0JSV/
         aBPkL8wY/MFGFHct0DXuJ7vxLd4K7KuFe+17A=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net
Subject: [PATCH 0/2] perf stat: add -l <N> option to redirect stderr elsewhere
Date: Sat, 21 May 2011 02:56:41 -0600
Message-Id: <1305968203-14240-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/2] perf stat: add -l <N> option to redirect stderr elsewhere
[PATCH 2/2] dont commify big numbers by default, let -B do it

perl's make test.valgrind uses valgrinds --log-fd option to steer
valgrind output to a file for further processing.  Adding similar to
perf will allow easy adaptation of the test harness to use perf too.

