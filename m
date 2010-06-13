Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0FMO7t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 10:59:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58932 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab0FMO7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 10:59:45 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Dave Airlie" <airlied@gmail.com>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
In-Reply-To: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <YPGdyfWGvNK.A.z4F.d5OFMB@chimera>
Subject: [Bug #16162] SSD + sata_nv + btrfs oops
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Jun 2010 16:49:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16162
Subject		: SSD + sata_nv + btrfs oops
Submitter	: Dave Airlie <airlied@gmail.com>
Date		: 2010-06-01 3:04 (13 days old)
Message-ID	: <AANLkTilqsIdlzZgUf7TMLHYKqHDZoVkcs42vcG8wXKEr@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127536149022333&w=2


