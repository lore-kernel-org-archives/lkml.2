Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab2IFOmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:42:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22913 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab2IFOmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:42:45 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=0-4HISFYYNcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=lCWGTHJAsiIA:10 a=lVNSXnoet12_OyyF6fAA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346942563.1680.19.camel@gandalf.local.home>
Subject: Re: [PATCH] Add feature-removal-schedule.txt removal to
 feature-removal-schedule.txt
From: Steven Rostedt <rostedt@goodmis.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 06 Sep 2012 10:42:43 -0400
In-Reply-To: <CAM_iQpUHYDT2hnt3h8fF33rp3O9c_VjEftOFUj-qdMdUkxo1tw@mail.gmail.com>
References: <1346091725.19381.10.camel@pippen.local.home>
	 <CAM_iQpV9163UKQt8Kvroc6JyMQnv1tqG1rS5M2CBWzbo7XvJXQ@mail.gmail.com>
	 <1346773188.27919.13.camel@gandalf.local.home>
	 <CAM_iQpUHYDT2hnt3h8fF33rp3O9c_VjEftOFUj-qdMdUkxo1tw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 22:29 +0800, Cong Wang wrote:

> I don't think feature-removal-schedule.txt is for kernel users, it
> is a kind of a TODO list for kernel developers.

And this is exactly what Linus was complaining about. It shouldn't be
used as a TODO list for developers.

-- Steve


