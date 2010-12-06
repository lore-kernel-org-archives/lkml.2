Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab0LFPvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:51:11 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:44030 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750774Ab0LFPvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:51:10 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: BPwqMqcVM1lRJ2OMW0P5HMjxGdE.wwknCYPQD6M2bdmpUA9
 8zNCNUIfwzYSX4cLq2f4aZrvrZWL779CAKTFFoaENHDfkYQsIt5ah32Ids24
 9.fy.LfMxHl.F8e9kBqE_pVGPA44ojNdtecMhZB1NR7h_AxdUjZMj9W0ceoQ
 YwLvvWayqYaNdOBp859MHNELz76BWogeR18hN6cBHlOQHok2NQ.P1hEcWK4U
 wLRl_9UoOQkI-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 6 Dec 2010 09:51:07 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [rfc: cpuops adv V1 0/8] Cmpxchg and xchg support for cpu ops
In-Reply-To: <4CFA9685.20200@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.1012060949000.32000@router.home>
References: <20101202215340.562309713@linux.com> <4CFA9685.20200@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Dec 2010, Pekka Enberg wrote:

> Christoph, do you mind sending me a series that you think is stable enough for
> linux-next? The numbers are pretty impressive and I'd love to give them some
> testing locally and in linux-next.

I'd like to see the cpu ops *updates* patchset getting into -next and
then be hopefully merged for the next relased. The cpuops advanced
patchset (this one) can go into -next *after* the next merge phase.
