Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142Ab0GIADf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 20:03:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37989 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759039Ab0GIAAF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 20:00:05 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "boris64" <bugzilla.kernel.org@boris64.net>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
In-Reply-To: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TXb9XdQzJoD.A.05.CMmNMB@chimera>
Subject: [Bug #16322] WARNING: at /arch/x86/include/asm/processor.h:1005 read_measured_perf_ctrs+0x5a/0x70()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  9 Jul 2010 01:41:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16322
Subject		: WARNING: at /arch/x86/include/asm/processor.h:1005 read_measured_perf_ctrs+0x5a/0x70()
Submitter	: boris64 <bugzilla.kernel.org@boris64.net>
Date		: 2010-07-01 13:54 (8 days old)
Handled-By	: H. Peter Anvin <hpa@zytor.com>


