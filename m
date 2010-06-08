Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab0FHWQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 18:16:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39693 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932273Ab0FHWQc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 18:16:32 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Christian Casteyde" <casteyde.christian@free.fr>,
       "Venki" <venki@google.com>
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera>
In-Reply-To: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <C9Q3XEnHPeG.A.wqG.r8rDMB@chimera>
Subject: [Bug #16092] Caught 64-bit read from uninitialized memory in memtype_rb_augment_cb
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  9 Jun 2010 00:10:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16092
Subject		: Caught 64-bit read from uninitialized memory in memtype_rb_augment_cb
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2010-06-01 18:08 (8 days old)
Handled-By	: Venki <venki@google.com>
Patch		: https://bugzilla.kernel.org/show_bug.cgi?id=16092#c2


