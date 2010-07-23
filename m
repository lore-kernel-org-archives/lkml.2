Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab0GWLuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 07:50:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51596 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755931Ab0GWLuR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 07:50:17 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Jean-Marc Pigeon" <jmp@safe.ca>, "Patrick McHardy" <kaber@trash.net>
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
In-Reply-To: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <tneGvaw1wLL.A.JeC.R5XSMB@chimera>
Subject: [Bug #16184] Container, X86-64, i386, iptables rule
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 23 Jul 2010 13:47:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16184
Subject		: Container, X86-64, i386, iptables rule
Submitter	: Jean-Marc Pigeon <jmp@safe.ca>
Date		: 2010-06-12 04:17 (42 days old)
Handled-By	: Patrick McHardy <kaber@trash.net>


