Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0EIWEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 18:04:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33310 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863Ab0EIWEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 18:04:37 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "liubo" <liubo2009@cn.fujitsu.com>
References: <10aqDnTJcLO.A.mLE.48y5LB@chimera>
In-Reply-To: <10aqDnTJcLO.A.mLE.48y5LB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <HqroMXsT-CJ.A.FgE.D9y5LB@chimera>
Subject: [Bug #15935] [BUG] btrfs: report a direct-IO bug
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 May 2010 23:17:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.33.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15935
Subject		: [BUG] btrfs: report a direct-IO bug
Submitter	: liubo <liubo2009@cn.fujitsu.com>
Date		: 2010-05-06 1:47 (4 days old)
Message-ID	: <4BE21FC1.1010901@cn.fujitsu.com>
References	: http://marc.info/?l=linux-kernel&m=127311036803487&w=2


