Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab1FHDaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 23:30:00 -0400
Received: from mta21.charter.net ([216.33.127.81]:41629 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab1FHD36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 23:29:58 -0400
X-Authority-Analysis: v=1.1 cv=1b2X7W/SifksZeClH/haT1SUt4udqxFGF00pZw2/jJk=
 c=1 sm=1 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=r-7vyuCz4tiabvs8yzgA:9 a=anwSPipBIxZR740o5NwA:7
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: julia@diku.dk
Cc: rdunlap@xenotime.net, Gilles.Muller@lip6.fr, npalix.work@gmail.com,
        cocci@diku.dk, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: coccicheck: Add M= option
Date: Tue,  7 Jun 2011 22:29:32 -0500
Message-Id: <1307503774-30370-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for M= to coccicheck. This makes 
using Coccinelle easier for those wishing to check specific
drivers or sub systems with Coccinelle.

Thanks!
Greg

[PATCH 1/2] coccinelle.txt update documentation to include M= option
[PATCH 2/2] coccicheck: add M option to control which dir is processed
