Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227Ab0ENKbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 06:31:23 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:36913 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab0ENKbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 06:31:22 -0400
Subject: usb debug port documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jason Wessel <jason.wessel@windriver.com>, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 12:31:16 +0200
Message-ID: <1273833076.4950.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.92.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been looking at
http://www.kernel.org/doc/Documentation/x86/earlyprintk.txt and spent a
while finding everything correctly in place. One of the big unknowns is
what way debug ports are enumerated, so if you have a few USB ports you
end up trying a lot. At the same time, I at least wasn't sure I was
doing everything correctly to start with. It does seem, for example,
that I needed the serial driver built in the kernel too?

In any case, to help others I was wondering if we should start a wiki
page somewhere or so that just lists what port on various machines
people have gotten it to work on? I have a Toshiba Satellite U505 and
earlyprintk=dbgp,keep uses the port on the right-hand side of the
machine... That information could possibly help somebody who is setting
it up for the first time, since it reduces the search space? :)

If there's an appropriate wiki, I'd like to be pointed to it so I can
start a page and submit a kernel patch pointing to it. Otherwise I'll
just create it internally since we all typically use just a handful of
machine types, but it seems like public could help more people.

johannes

