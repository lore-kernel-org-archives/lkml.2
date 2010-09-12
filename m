Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab0ILSfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:35:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47125 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab0ILSeb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:34:31 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Sergey Senozhatsky" <sergey.senozhatsky@gmail.com>
References: <EP3NUDNWMO.A.O0.rrRjMB@chimera>
In-Reply-To: <EP3NUDNWMO.A.O0.rrRjMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <0c5PAlgnPrH.A.JiB.EsRjMB@chimera>
Subject: [Bug #17331] BUG: scheduling while atomic
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 12 Sep 2010 20:14:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.35.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17331
Subject		: BUG: scheduling while atomic
Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Date		: 2010-08-27 7:59 (17 days old)
Message-ID	: <20100827075911.GA5966@swordfish.minsk.epam.com>
References	: http://marc.info/?l=linux-kernel&m=128289602925505&w=2


