Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060Ab0GIAAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 20:00:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37990 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759040Ab0GIAAF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 20:00:05 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Andrew Hendry" <andrew.hendry@gmail.com>,
       "Jeff Layton" <jlayton@redhat.com>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
In-Reply-To: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TXb9XdQzJoD.A.DhB.SMmNMB@chimera>
Subject: [Bug #16306] 2.6.35-rc3 BUG: unable to handle kernel NULL pointer dereference at 0000000000000048 cifs_show_options
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  9 Jul 2010 01:41:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16306
Subject		: 2.6.35-rc3 BUG: unable to handle kernel NULL pointer dereference at 0000000000000048 cifs_show_options
Submitter	: Andrew Hendry <andrew.hendry@gmail.com>
Date		: 2010-06-26 10:46 (13 days old)
Message-ID	: <AANLkTilhTrEBYZd4HxeXQk8B6-yV8rCJ2C0jXsEREgIR@mail.gmail.com>
References	: http://marc.info/?l=linux-kernel&m=127754922110501&w=2
Handled-By	: Jeff Layton <jlayton@redhat.com>


