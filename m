Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab2BWXOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:14:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39727 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756092Ab2BWXNi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:13:38 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "Dave Airlie" <airlied@redhat.com>,
        "Hans de Bruin" <jmdebruin@xmsnet.nl>,
        "Jesse Barnes" <jbarnes@virtuousgeek.org>,
        "=?utf-8?q?Ville=20Syrj=C3=83=C2=A4l=C3=83=C2=A4?=" 
	<ville.syrjala@linux.intel.com>
References: <y44pDJ8xoDC.A.08E.h8rRPB@chimera>
In-Reply-To: <y44pDJ8xoDC.A.08E.h8rRPB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <qCQH7HfZS8E.A.poF.18rRPB@chimera>
Subject: [Bug #42734] dosemu graphics broken in v3.3-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 23 Feb 2012 23:55:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 3.2.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42734
Subject		: dosemu graphics broken in v3.3-rc1
Submitter	: Hans de Bruin <jmdebruin@xmsnet.nl>
Date		: 2012-02-02 22:25 (22 days old)
First-Bad-Commit: http://git.kernel.org/linus/308e5bcbdb10452e8aba31aa21432fb67ee46d72
Message-ID	: <4F2B0D4D.3000304@xmsnet.nl>
References	: http://marc.info/?l=linux-kernel&m=132825899111982&w=2
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


