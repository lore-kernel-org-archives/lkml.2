Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1KGJ2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 04:28:44 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:42642 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab1KGJ2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 04:28:43 -0500
Subject: htmldocs broken
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Nov 2011 10:28:34 +0100
Message-ID: <1320658114.3993.31.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I frequently run

make htmldocs DOCBOOKS=80211.xml

because I don't want to build all of it. I guess since "[media] DocBook:
Move all media docbook stuff into its own directory", this is broken:

$ make htmldocs DOCBOOKS=80211.xml
  HTML    Documentation/DocBook/80211.html
rm -rf Documentation/DocBook/index.html; echo '<h1>Linux Kernel HTML Documentation</h1>' >> Documentation/DocBook/index.html && echo '<h2>Kernel Version: 3.1.0</h2>' >> Documentation/DocBook/index.html && cat Documentation/DocBook/80211.html >> Documentation/DocBook/index.html
cp: target `/home/johannes/sys/laptop/Documentation/DocBook//media_api' is not a directory

Any thoughts about how to fix it?

johannes

