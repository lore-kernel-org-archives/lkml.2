Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab2JHSph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 14:45:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab2JHSpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 14:45:33 -0400
X-Authority-Analysis: v=2.0 cv=e+uEuNV/ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=43-t_W6Wc20A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ncH_GnA0bfYA:10 a=VwQbUJbxAAAA:8 a=fDxnOkSxeihCrMUJV7oA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349721932.6755.117.camel@gandalf.local.home>
Subject: [ANNOUNCE] Stable release of trace-cmd v2.0
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Kacur <jkacur@redhat.com>, Mel Gorman <mgorman@suse.de>
Date: Mon, 08 Oct 2012 14:45:32 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm happy to inform you that I've released trace-cmd v2.0

It's not much different than the stable 1.x series, but it has changed
enough to warrant a new version number.

I've also backported a bunch of patches to the 1.2 release and posted
that one as well.

You can get the latest code from:

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git

   master holds the latest updates

   trace-cmd-stable-v2.0 - is the v2.0 branch

   trace-cmd-stable-v1.2 - is the v1.2 branch.

Note, I will probably push out a 1.0 update too, but that will be the
last one I do. I'll backport to 1.2 but I will not be backporting to the
1.0 version anymore (and I've stopped backporting to 1.1).

Enjoy,

-- Steve


