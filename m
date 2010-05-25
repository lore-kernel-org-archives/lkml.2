Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab0EYPfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:35:13 -0400
Received: from bluebox.CS.Princeton.EDU ([128.112.136.38]:34649 "EHLO
	bluebox.CS.Princeton.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab0EYPfM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:35:12 -0400
X-Greylist: delayed 907 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 May 2010 11:35:11 EDT
From: "=?utf-8?Q?=22S.=C3=87a=C4=9Flar_Onur=22?=" <caglar@CS.Princeton.EDU>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Boot failure with 2.6.27.46 on Xeon E5620 (Westmere EP)
Date: Tue, 25 May 2010 11:10:28 -0400
Message-Id: <000954C6-B4AC-4FD8-BA3B-C3B199C7607F@CS.Princeton.EDU>
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, hpa@zytor.com
To: stable@kernel.org
Mime-Version: 1.0 (Apple Message framework v1078)
X-Mailer: Apple Mail (2.1078)
X-Proofpoint-Virus-Version: vendor=nai engine=5400 definitions=5992 signatures=621959
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We are observing boot failures [1] & [2] on some of our servers (Dell r410) with 2.6.27-stable kernels. I found following commit in upstream tree via a quick search (but I haven't tried it yet) so I don't know whether I'm on the right track or not. 

Please let me know if anything else is needed...

commit d0af9eed5aa91b6b7b5049cae69e5ea956fd85c3
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Wed Aug 19 18:05:36 2009 -0700

    x86, pat/mtrr: Rendezvous all the cpus for MTRR/PAT init
[…]

[1] http://www.cs.princeton.edu/~caglar/2.6.27/idle=mwait.png
[2] http://www.cs.princeton.edu/~caglar/2.6.27/idle=poll.png

Best regards,
--
S.Çağlar Onur <caglar@cs.princeton.edu>

