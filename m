Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab1FZVrz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 17:47:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59368 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388Ab1FZVqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 17:46:55 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "Andrew" <atswartz@gmail.com>
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera>
In-Reply-To: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <XWjMN7gBoXK.A.JRD.hZ6BOB@chimera>
Subject: [Bug #37562] /scripts/depmod.sh ends up -rw-r--r-- 1 depmod.sh
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jun 2011 23:23:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.39.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37562
Subject		: /scripts/depmod.sh ends up -rw-r--r-- 1 depmod.sh
Submitter	: Andrew <atswartz@gmail.com>
Date		: 2011-06-15 23:49 (12 days old)


