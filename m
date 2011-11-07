Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab1KGRMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 12:12:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49952 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab1KGRMR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 12:12:17 -0500
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.1
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Stephane Eranian <eranian@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, eric.dumazet@gmail.com,
        shaohua.li@intel.com, ak@linux.intel.com, mhocko@suse.cz,
        alex.shi@intel.com, efault@gmx.de, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>
Date: Mon, 07 Nov 2011 18:11:06 +0100
In-Reply-To: <20111107165603.GD2332@linux.vnet.ibm.com>
References: <20111027075901.GB2313@linux.vnet.ibm.com>
	 <20111027080016.GA16885@elte.hu> <4EAA14A1.5060204@cn.fujitsu.com>
	 <20111029182710.GG6160@linux.vnet.ibm.com>
	 <4EAE57AF.1060706@cn.fujitsu.com>
	 <20111031093256.GI6160@linux.vnet.ibm.com>
	 <4EAF5B68.8090005@cn.fujitsu.com> <1320678902.18053.63.camel@twins>
	 <CABPqkBTbWE6wVkg_sFnoVL0r4_yi6gCwCoUXzC97kxcxC47zYQ@mail.gmail.com>
	 <1320683756.17809.28.camel@twins>
	 <20111107165603.GD2332@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320685866.17809.31.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 08:56 -0800, Paul E. McKenney wrote:
> > > code has a problem.
> > 
> > yeah, task_struct is rcu-freed
> 
> But we are not in an RCU read-side critical section, otherwise the splat
> would not have happened.  Or did I miss a turn in the analysis roadmap
> above? 

I think cgroup code does get_task_struct()/put_task_struct().
