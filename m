Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab2EWOb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:31:57 -0400
Received: from mxintern.schlund.de ([212.227.126.201]:62262 "EHLO
	mxintern.schlund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000Ab2EWObz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:31:55 -0400
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 May 2012 10:31:55 EDT
Message-ID: <1337783193.1886.104.camel@tst0.s.schlund.de>
Subject: block level: new tool "blkreplay" for tests / benchmarking
From: Thomas =?ISO-8859-1?Q?Sch=F6bel-Theuer?= 
	<thomas.schoebel-theuer@1und1.de>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Thomas =?ISO-8859-1?Q?Sch=F6bel-Theuer?= 
	<Thomas.Schoebel-Theuer@1und1.de>
Date: Wed, 23 May 2012 16:26:33 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-UI-Msg-Verification: b6beba6c2e442b8d8243815f1303d4b5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

in some sense, blkreplay is just the opposite of the well-known kernel
tool blktrace: recordings of (natural) loads can be replayed in the
laboratory, measuring IO latencies (and other indicators) for later
visualization (so-called "sonar diagrams"), e.g. for comparison of IO
schedulers, or driver overhead, or network latencies, or hardware.

While blkreplay itself is a rather simple tool, the real value of the
GPL'ed blkreplay project might be the large collection of natural loads,
stemming from datacenters at 1&1.

The public collection of natural loads covers a broad range of
applications, such as databases (even commercial ones like Oracle),
shared hosting, virtualized servers, etc. Some loads are even 24h
recordings. The collection will be enhanced during the next few days
(internally at 1&1, we have already more than 1000 blktrace recordings,
so our main problem is selecting the "interesting" ones, otherwise you
could be overwhelmed).

blkreplay comes with a comprehensive manual of already 57 pages, which
will be extended during the next weeks.

Introduction / Abstract: www.blkreplay.org or
https://github.com/schoebel/blkreplay/wiki

Manual:
https://github.com/schoebel/blkreplay/raw/master/doc/blkreplay.pdf

Source code: https://github.com/schoebel/blkreplay

Collection of loads: http://www.blkreplay.org/loads/

Enjoy,

Thomas


