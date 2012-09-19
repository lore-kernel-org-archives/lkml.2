Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab2ISWES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 18:04:18 -0400
Received: from nm9-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.139]:34061 "HELO
	nm9-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752373Ab2ISWEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 18:04:16 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2012 18:04:16 EDT
X-Yahoo-Newman-Id: 368354.86779.bm@omp1003.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: TUGNF0oVM1lr3rSLQgHUOpFfKPPjSfXrRr1hFrAKouaalhY
 Fn0bc7WbsulOL0RvF.7aDXwQkIscK2wGafw5bWP4_GGGiehbwu7i6tYZCxgH
 s0udDHKisGyUSIDh0.hloHUcG70OsHQ24s.3lSyXN2sJEMEAnhgc8JWIkWjD
 won4PQoBZTffSw.oCTVVQz8xhpp3SA6YmUchuyWMZRFm9aXsMu5RYPR.ZAHa
 DO.oufnt5cwBUxuL9c.WsY.38f3ghczf3HEOU01VQbWPViUHo6kZM0_Zud0V
 xEj4AGK1dyo8C1WDQd_VLyuWfS2cE3eh9g6tVEqcGq4669PiUEiU7ET80p6I
 xqpnxz1U3PyZ6LpGYD0AKWlkE8ULdiJfvto0jvdJgGxaZxg2i1wIYdJdLqal
 sFjW40W68VrXAGYuHf_HdPgk-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <505A3EAB.2030002@att.net>
Date: Wed, 19 Sep 2012 16:52:43 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Where to put test code?
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm putting the finishing touches on the generic red-black tree test
code, but I'm uncertain about where to place it exactly.

I haven't finished the test module just yet, but the idea is that the
tests can be run in userspace as well as kernelspace to make it easier
to test on multiple compilers.  It has some common sources files (used
by in both places) and then specific code for both user- and
kernel-space that I currently have as follows:

tools/testing/selftests/grbtree/       - common.{c,h}
tools/testing/selftests/grbtree/user   - user-space main.c, Makefile, etc.
tools/testing/selftests/grbtree/module - kernel-space grbtest.c,
Makefile, etc.

Would this be correct or should the common & module code go some place
else and then just have the user-space code under
tools/testing/selftests/grbtest?

Thanks
Daniel


