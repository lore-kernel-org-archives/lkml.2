Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab2HVIcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:32:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab2HVIcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:32:15 -0400
Date: Wed, 22 Aug 2012 10:31:34 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@kernel.org, eranian@google.com, acme@redhat.com, gorcunov@openvz.org,
        benjamin.redelings@nescent.org, fweisbec@gmail.com,
        robert.richter@amd.com, drepper@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, asharma@fb.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
        tzanussi@gmail.com, masami.hiramatsu.pt@hitachi.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf tools: Adding PERF_ATTR_SIZE_VER2 to the
 header swap check
Message-ID: <20120822083134.GA1003@krava.brq.redhat.com>
References: <1344345647-11536-8-git-send-email-jolsa@redhat.com>
 <tip-239cc47819ec5e1acde42d416755c332ed5cf2c8@git.kernel.org>
 <1345569130.26596.5.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345569130.26596.5.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 07:12:10PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-08-21 at 08:51 -0700, tip-bot for Jiri Olsa wrote:
> > @@ -1829,6 +1829,7 @@ out_free:
> >  static const int attr_file_abi_sizes[] = {
> >         [0] = PERF_ATTR_SIZE_VER0,
> >         [1] = PERF_ATTR_SIZE_VER1,
> > +       [2] = PERF_ATTR_SIZE_VER2,
> >         0,
> >  }; 
> 
> Didn't we just get to VER4 ?

that's leftover for the branch_sample_type addition

jirka
