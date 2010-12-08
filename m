Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab0LHRbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:31:33 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:24163 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755130Ab0LHRbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:31:32 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: nywU5E4VM1mnb2ysf_5pC3MLiwHk4QYezTmTfa.oHohkx5o
 NcPPmdqbbRJYP4TXKclUEdRv1f3Fb7bKtpg5pBy.mdxtk3Gu3412LB8EEngi
 DIZErX_P1KV5Bo5n0d4UwamKPuFOeps8BbWd34sbAHHw1YBv7x9nEMkJXXF.
 9edPdUzCS__YvTSKd.y1eNzd8p40bHa7Kv93lajAAbvy_jTn.RwH3JunZbgY
 xeeK_s9GFvML6VEpiXNnNfjmkR7X6f2RgzJbwbk.U5KUldAy7lukBnQwRJXH
 XUIta4GAZvTo8BQedXWtt
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 8 Dec 2010 11:31:29 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops inc_return V1 3/9] x86: Use this_cpu_inc_return for nmi
 counter
In-Reply-To: <4CFFB642.6000207@kernel.org>
Message-ID: <alpine.DEB.2.00.1012081131000.23407@router.home>
References: <20101206173958.685460926@linux.com> <20101206174014.806809612@linux.com> <4CFFB642.6000207@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Dec 2010, Tejun Heo wrote:

> On 12/06/2010 06:40 PM, Christoph Lameter wrote:
> > this_cpu_inc_return() saves us a memory access there.
> >
> > Reviewed-by: Tejun Heo <tj@kernel.org>
> > Reviewed-by: Pekka Enberg <penberg@kernel.org>
> > Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Signed-off-by: Christoph Lameter <cl@linux.com>
>
> 03-05, the updated 06, 07-09 and the connector patch applied and
> pushed out to percpu#for-next.

Great. Then you are ready for the next set with the this_cpu_cmpxchg
stuff?

