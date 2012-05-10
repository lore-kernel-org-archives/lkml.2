Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab2EJQi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:38:59 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:12069 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2EJQi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:38:57 -0400
Message-ID: <1336667932.2581.23.camel@lorien2>
Subject: Re: [PATCH 1/5] Fix soft-lookup in stop machine on secondary cpu
 bring up
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Igor Mammedov <imammedo@redhat.com>
Cc: shuahkhan@gmail.com, linux-kernel@vger.kernel.org, rob@landley.net,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        luto@mit.edu, suresh b siddha <suresh.b.siddha@intel.com>,
        avi@redhat.com, a p zijlstra <a.p.zijlstra@chello.nl>,
        johnstul@us.ibm.com, arjan@linux.intel.com, linux-doc@vger.kernel.org
Date: Thu, 10 May 2012 10:38:52 -0600
In-Reply-To: <8c0f597c-b2a7-4599-9d9f-c4c81412318a@zmail16.collab.prod.int.phx2.redhat.com>
References: <8c0f597c-b2a7-4599-9d9f-c4c81412318a@zmail16.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 12:29 -0400, Igor Mammedov wrote:
> just cloned git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> last commit 0bed306
> 
> All 5 patches applied cleanly, maybe we are talking about different linux-next trees?

The same git from May 8th. The commit id I have is
407655a15be465ca284a68843e66c6fe7decf4bc. Let me try again.

-- Shuah

