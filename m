Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab0DTEAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 00:00:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48757 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab0DTEAm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 00:00:42 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Andy Isaacson" <adi@hexapodia.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Yinghai Lu" <yinghai@kernel.org>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
In-Reply-To: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <YeFfFNFyTSF.A.H5G.bRSzLB@tosh>
Subject: [Bug #15744] [2.6.34-rc1 REGRESSION] ahci 0000:00:1f.2: controller reset failed (0xffffffff)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 20 Apr 2010 05:19:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.33.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15744
Subject		: [2.6.34-rc1 REGRESSION] ahci 0000:00:1f.2: controller reset failed (0xffffffff)
Submitter	: Andy Isaacson <adi@hexapodia.org>
Date		: 2010-04-06 22:54 (14 days old)
Message-ID	: <<4BC51312.6080302@oracle.com></desc>>
References	: http://marc.info/?l=linux-kernel&m=127059449031511&w=2


