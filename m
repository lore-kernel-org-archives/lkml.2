Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab0GHX6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:58:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37879 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758909Ab0GHX6P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:58:15 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Marcin Slusarz" <marcin.slusarz@gmail.com>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
In-Reply-To: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TXb9XdQzJoD.A.sND.dNmNMB@chimera>
Subject: [Bug #16205] acpi: freeing invalid memtype bf799000-bf79a000
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri,  9 Jul 2010 01:41:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16205
Subject		: acpi: freeing invalid memtype bf799000-bf79a000
Submitter	: Marcin Slusarz <marcin.slusarz@gmail.com>
Date		: 2010-06-09 20:09 (30 days old)
Message-ID	: <20100609200910.GA2876@joi.lan>
References	: http://marc.info/?l=linux-kernel&m=127611427029914&w=2
		  http://marc.info/?l=linux-kernel&m=127688398513862&w=2


