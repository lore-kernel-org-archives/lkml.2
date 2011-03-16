Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab1CPOjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 10:39:16 -0400
Received: from qmta09.westchester.pa.mail.comcast.net ([76.96.62.96]:46628
	"EHLO qmta09.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751137Ab1CPOjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 10:39:11 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Mar 2011 10:39:11 EDT
Date: Wed, 16 Mar 2011 10:33:18 -0400
From: Frank Peters <frank.peters@comcast.net>
To: linux-kernel@vger.kernel.org
Subject: 2.6.38 Compile Failure e1000e Module
Message-Id: <20110316103318.19bd03e4.frank.peters@comcast.net>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I cannot compile kernel 2.6.38.  Apparently, there is a build failure
with the e1000e module (ethernet driver).  The brief error message is this:

ERROR: "crc32_le" [drivers/net/e1000e/e1000e.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

My compiler is gcc-4.5.2 on a Gentoo x64 system.  The kernel source
is the stock source from kernel.org.

Please CC to frank.peters (at) comcast.net.

Frank Peters
