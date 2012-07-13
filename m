Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab2GMOTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 10:19:17 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:27348 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757647Ab2GMOTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 10:19:15 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: TfVH12AVM1mlLUgo.V0DU9jItufwDNJXfZ3noDYl2lU4ajE
 ILGkPkYHgxY0moTlQ.50KrAbRFcSM7ZDsr1Rjagm.nL0i4vYFiASWtmQ5Fif
 4F8pXa0NSHYTHFv4AojAqqHgg4WKzvZLLdiCqCzNLW4Ymj9FenE7EA1MyV2U
 p0lKfd52ftKt9XhTRd.l791hjW4z__qu1y3Fxlze5Ad.BZ1EweF_lv19Msgo
 S6TduC0NsTE6Lea3eOLRxRLKHkoDVJZ5a.5jxDyeqUrEXrSPngO86AtxPS8b
 mtOli3cl8n.XUxHbLX4KcorO37UHmAk99b_JOpjiw_T4C9_PjKiej5ZUanC.
 ylqcBkmm0exzG8FSy0mWac9rOHSuX40RPpwArR1J.aeoePNKKVMAjoqMVf_Q
 L
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 13 Jul 2012 09:19:06 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrea Arcangeli <aarcange@redhat.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
        Rik van Riel <riel@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 20/40] autonuma: alloc/free/init mm_autonuma
In-Reply-To: <20120712181738.GA1349@cmpxchg.org>
Message-ID: <alpine.DEB.2.00.1207130918320.24910@router.home>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com> <1340888180-15355-21-git-send-email-aarcange@redhat.com> <20120630051217.GG3975@localhost.localdomain> <20120712180828.GL20382@redhat.com> <20120712181738.GA1349@cmpxchg.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012, Johannes Weiner wrote:

> On Thu, Jul 12, 2012 at 08:08:28PM +0200, Andrea Arcangeli wrote:
> > On Sat, Jun 30, 2012 at 01:12:18AM -0400, Konrad Rzeszutek Wilk wrote:
> > > On Thu, Jun 28, 2012 at 02:56:00PM +0200, Andrea Arcangeli wrote:
> > > > This is where the mm_autonuma structure is being handled. Just like
> > > > sched_autonuma, this is only allocated at runtime if the hardware the
> > > > kernel is running on has been detected as NUMA. On not NUMA hardware
> > >
> > > I think the correct wording is "non-NUMA", not "not NUMA".
> >
> > That sounds far too easy to me, but I've no idea what's the right is here.
>
> UMA?
>
> Single-node hardware?

Lets be simple and stay with non-NUMA.


