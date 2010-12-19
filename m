Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab0LSMlL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 07:41:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38469 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756628Ab0LSMlI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 07:41:08 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>
References: <wNJKqSoEutL.A.lKD.odfDNB@chimera>
In-Reply-To: <wNJKqSoEutL.A.lKD.odfDNB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6Ue85L6pKCJ.A.1wD.GefDNB@chimera>
Subject: [Bug #24592] 2.6.37-rc5: NULL pointer oops in selinux_socket_unix_stream_connect
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 19 Dec 2010 13:34:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.36.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24592
Subject		: 2.6.37-rc5: NULL pointer oops in selinux_socket_unix_stream_connect
Submitter	: Jeremy Fitzhardinge <jeremy@goop.org>
Date		: 2010-12-08 21:09 (12 days old)
Message-ID	: <4CFFF3F3.90100@goop.org>
References	: http://marc.info/?l=linux-kernel&m=129184256629712&w=2


