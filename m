Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031191Ab2CUOVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:21:14 -0400
Received: from service87.mimecast.com ([91.220.42.44]:59764 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656Ab2CUOVN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:21:13 -0400
Date: Wed, 21 Mar 2012 14:20:27 +0000
From: Morten Rasmussen <Morten.Rasmussen@arm.com>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Benjamin Segall <bsegall@google.com>,
        Ranjit Manomohan <ranjitm@google.com>, Nikhil Rao <ncrao@google.com>,
        "jmc@cs.unc.edu" <jmc@cs.unc.edu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Abhishek Srivastava <a.srivastava.800@gmail.com>
Subject: Re: [ANNOUNCE] LinSched for v3.3-rc7
Message-ID: <20120321142026.GA29148@e103034-lin.cambridge.arm.com>
References: <CAPM31RL6Sk6cNR9MzW_7XDvfkMA1q6xK_mcJJaCMY8Ex___9+A@mail.gmail.com>
 <CAPhKKr-W+nh9Xzmwz83MUpzPuBfkj_TxjiZ+8NA5hndDUQB7bA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPhKKr-W+nh9Xzmwz83MUpzPuBfkj_TxjiZ+8NA5hndDUQB7bA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Mar 2012 14:21:16.0260 (UTC) FILETIME=[E07B0240:01CD076D]
X-MC-Unique: 112032114205019101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 15, 2012 at 04:08:17AM +0000, Dhaval Giani wrote:
> [Adding abhishek to the cc]
> 
> On Wed, Mar 14, 2012 at 8:58 PM, Paul Turner <pjt@google.com> wrote:
> > - Support for record and replay of application scheduling via perf.
> > This is not yet well integrated, but under tests exist the tools to
> > record an applications behavior using perf sched record, and then play
> > it back in the simulator.

I am interested in testing this feature and I could use a hint on how to
get it working. tests/perf_replay.c seems to accept perf sched record
traces which have been post-processed into .rlog traces. Where can I
find a tool to generate rlogs from perf traces?

Thanks,
Morten

