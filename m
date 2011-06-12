Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab1FLUlg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 16:41:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49917 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776Ab1FLUl2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 16:41:28 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Alex Zhavnerchik" <alex.vizor@gmail.com>
References: <vv0uv79EvLN.A.jiC.pNS9NB@chimera>
In-Reply-To: <vv0uv79EvLN.A.jiC.pNS9NB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <JL7O0m0yLjL.A.lED.FOS9NB@chimera>
Subject: [Bug #36302] SandyBridge can't do s2disk with linux 3.0-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 12 Jun 2011 22:23:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.39.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=36302
Subject		: SandyBridge can't do s2disk with linux 3.0-rc1
Submitter	: Alex Zhavnerchik <alex.vizor@gmail.com>
Date		: 2011-05-30 23:10 (14 days old)


