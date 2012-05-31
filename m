Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab2EaST2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:19:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56134 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057Ab2EaST1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:19:27 -0400
Message-ID: <1338488339.28384.106.camel@twins>
Subject: Re: [PATCH 13/35] autonuma: add page structure fields
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Hillf Danton <dhillf@gmail.com>,
        Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Date: Thu, 31 May 2012 20:18:59 +0200
In-Reply-To: <20120530134953.GD21339@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
	 <1337965359-29725-14-git-send-email-aarcange@redhat.com>
	 <1338297385.26856.74.camel@twins> <4FC4D58A.50800@redhat.com>
	 <1338303251.26856.94.camel@twins> <4FC5D973.3080108@gmail.com>
	 <1338368763.26856.207.camel@twins> <20120530134953.GD21339@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 15:49 +0200, Andrea Arcangeli wrote:
> 
> I'm thinking about it but probably reducing the page_autonuma to one
> per pmd is going to be the simplest solution considering by default we
> only track the pmd anyway. 

Do also consider that some archs have larger base page size. So their
effective PMD size is increased as well.
