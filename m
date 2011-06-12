Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab1FLVdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 17:33:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50118 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233Ab1FLVao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 17:30:44 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Ko Mi" <chaostya.test@hotmail.com>
References: <9NVbY1BZ_5D.A.2lE.jzS9NB@chimera>
In-Reply-To: <9NVbY1BZ_5D.A.2lE.jzS9NB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <kTLfM29CaqB.A.DaF.p0S9NB@chimera>
Subject: [Bug #35242] NULL pointer dereference in intel_sdvo_write_cmd (was Black screen after boot)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 12 Jun 2011 23:12:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.38 and 2.6.39.

The following bug entry is on the current list of known regressions
introduced between 2.6.38 and 2.6.39.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=35242
Subject		: NULL pointer dereference in intel_sdvo_write_cmd (was Black screen after boot)
Submitter	: Ko Mi <chaostya.test@hotmail.com>
Date		: 2011-05-17 10:27 (27 days old)


