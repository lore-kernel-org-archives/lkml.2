Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab0ILSec (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:34:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47119 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878Ab0ILSe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:34:29 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Jeff Layton" <jlayton@redhat.com>
References: <EP3NUDNWMO.A.O0.rrRjMB@chimera>
In-Reply-To: <EP3NUDNWMO.A.O0.rrRjMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <0c5PAlgnPrH.A.V6.wrRjMB@chimera>
Subject: [Bug #17952] bdi-default hung waiting for kthread_stop to finish
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 12 Sep 2010 20:14:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.35.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17952
Subject		: bdi-default hung waiting for kthread_stop to finish
Submitter	: Jeff Layton <jlayton@redhat.com>
Date		: 2010-09-02 18:55 (11 days old)
Message-ID	: <20100902145509.28e4f998@tlielax.poochiereds.net>
References	: http://marc.info/?l=linux-kernel&m=128345371904504&w=2


