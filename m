Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761421Ab2FEDtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 23:49:01 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:36958 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761366Ab2FEDtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 23:49:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+L6uI3Ea2LTrJnQ/Y1m2XL8qN1LDnum79vZ+AT8N
	bVViYaARACCTbc
Message-ID: <1338868135.7356.5.camel@marge.simpson.net>
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
From: Mike Galbraith <efault@gmx.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vladimir Davydov <vdavydov@parallels.com>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 05 Jun 2012 05:48:55 +0200
In-Reply-To: <4FCCD6B7.4030703@linux.intel.com>
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>
	 <1338805967.28282.12.camel@twins> <4FCCB486.4040905@linux.intel.com>
	 <1338817519.28282.54.camel@twins> <4FCCBC97.8060101@linux.intel.com>
	 <1338822509.28282.65.camel@twins> <4FCCD0CD.8080700@linux.intel.com>
	 <1338823568.28282.79.camel@twins> <4FCCD6B7.4030703@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 08:39 -0700, Arjan van de Ven wrote:

> if there is a lot of idle, load can be low or high; load is more than
> just cpu usage. it includes waiting for resources and mutexes etc.

05:40:42 up 39 min, 20 users,  load average: 0.63, 0.53, 0.42
root     pts/11    05:03    5:05   6:16   0.00s /bin/sh /root/bin/tbench.sh 1 400

Like scheduling something cross core that is close to being synchronous.

-Mike

