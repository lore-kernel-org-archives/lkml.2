Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab1H1TNf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 15:13:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43427 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab1H1TNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 15:13:30 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "=?utf-8?q?Fran=C3=A7ois=20Valenduc?=" 
	<francois.valenduc@tvcablenet.be>,
        "Matthew Garrett" <mjg@redhat.com>
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera>
In-Reply-To: <lx6sezwGldO.A.IhF.UBpWOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sfuyzWlorBN.A.OlF.ZBpWOB@chimera>
Subject: [Bug #41742] duplicate filename  for intel_backlight with the i915 driver
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 28 Aug 2011 20:30:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 3.0.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=41742
Subject		: duplicate filename  for intel_backlight with the i915 driver
Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
Date		: 2011-08-25 18:51 (4 days old)
First-Bad-Commit: http://git.kernel.org/linus/aaa6fd2a004147bf32fce05720938236de3361d9


