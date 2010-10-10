Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab0JJTWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 15:22:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32964 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab0JJTWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 15:22:44 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Mickey86" <mikael.cordon@gmail.com>
References: <pyPtebg28EI.A.ZPH.NvgsMB@chimera>
In-Reply-To: <pyPtebg28EI.A.ZPH.NvgsMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <yeAD7A8RDxC.A.ivH.uvgsMB@chimera>
Subject: [Bug #17812] Kernel completely frozen when memory is full
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Oct 2010 21:18:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.34 and 2.6.35.

The following bug entry is on the current list of known regressions
introduced between 2.6.34 and 2.6.35.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17812
Subject		: Kernel completely frozen when memory is full
Submitter	: Mickey86 <mikael.cordon@gmail.com>
Date		: 2010-09-05 13:09 (36 days old)


