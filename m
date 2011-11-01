Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab1KARTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 13:19:25 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56945 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab1KARTY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 13:19:24 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 1 Nov 2011 18:19:20 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Lars =?UTF-8?B?Tm9vZMOpbg==?= <lars.nooden@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: where to report bugs while bugzilla.kernel.org is down?
Message-ID: <20111101181920.2c6655dd@stein>
In-Reply-To: <4EB0205E.4050602@gmail.com>
References: <4EB0205E.4050602@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 01 Lars Noodén wrote:
> bugzilla.kernel.org has been down for a while and it may be a while
> before it is up again.  In the mean time how should bugs be reported?
> 
> 	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/881593

Bugs should be reported on LKML and/or if applicable on a respective
subsystem mailinglist.  (See MAINTAINERS file of the kernel source.)

Even when bugzilla.kernel.org comes back, report bugs preferably to
mailinglists.  Bugzilla is a bug tracker, not so much a reporting tool.
Some maintainers and the good people who track kernel regressions make use
of bugzilla.kernel.org to keep record of bugs.  Furthermore, it can of
course be used by reporters too especially if they need to upload
screenshots of a kernel panic or large log files etc..

(That said, bug reports which are entered into bugzilla instead of posted
to a mailinglist are usually forwarded to people or mailinglists who might
be able to handle them.)
-- 
Stefan Richter
-=====-==-== =-== ----=
http://arcgraph.de/sr/
