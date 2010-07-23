Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab0GWLpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 07:45:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51568 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590Ab0GWLpo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 07:45:44 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "David Hill" <hilld@binarystorm.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
In-Reply-To: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <tneGvaw1wLL.A.zlC.h5XSMB@chimera>
Subject: [Bug #16173] After uncompressing the kernel, at boot time, the server hangs.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 23 Jul 2010 13:42:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.34.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16173
Subject		: After uncompressing the kernel, at boot time, the server hangs.
Submitter	: David Hill <hilld@binarystorm.net>
Date		: 2010-06-09 23:25 (45 days old)
First-Bad-Commit: http://git.kernel.org/linus/cf7500c0ea133d66f8449d86392d83f840102632
Handled-By	: Eric W. Biederman <ebiederm@xmission.com>


