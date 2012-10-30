Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965793Ab2J3TXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:23:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12684 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab2J3TXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:23:48 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=D9mF2Ae23_0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=5DfaeP5S0toA:10 a=pGLkceISAAAA:8 a=6oUm_4n_ZOgxocesW1QA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351625023.4004.29.camel@gandalf.local.home>
Subject: Re: [PATCH v8 16/16] tracing output: use new hashtable
 implementation
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, tj@kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, mingo@elte.hu,
        ebiederm@xmission.com, aarcange@redhat.com, ericvh@gmail.com,
        netdev@vger.kernel.org, josh@joshtriplett.org, eric.dumazet@gmail.com,
        mathieu.desnoyers@efficios.com, axboe@kernel.dk, agk@redhat.com,
        dm-devel@redhat.com, neilb@suse.de, ccaulfie@redhat.com,
        teigland@redhat.com, Trond.Myklebust@netapp.com, bfields@fieldses.org,
        fweisbec@gmail.com, jesse@nicira.com, venkat.x.venkatsubra@oracle.com,
        ejt@redhat.com, snitzer@redhat.com, edumazet@google.com,
        linux-nfs@vger.kernel.org, dev@openvswitch.org,
        rds-devel@oss.oracle.com, lw@cn.fujitsu.com
Date: Tue, 30 Oct 2012 15:23:43 -0400
In-Reply-To: <1351622772-16400-16-git-send-email-levinsasha928@gmail.com>
References: <1351622772-16400-1-git-send-email-levinsasha928@gmail.com>
	 <1351622772-16400-16-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 14:46 -0400, Sasha Levin wrote:
> Switch tracing to use the new hashtable implementation. This reduces the
> amount of generic unrelated code in the tracing module.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve



