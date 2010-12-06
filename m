Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab0LFPwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:52:23 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:44420 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751821Ab0LFPwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:52:22 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: gus7RCsVM1nlPx0LNePaT9XgiqhPbxuIb1z42eAKOn0hk8.
 ezvRhyONb2tbVfrDD6J35_BeHKPK8hB4_gJS16wxpZHLLJgVtMsiCKYMN8iE
 F0XYcGJgsre_gBqAEc3Vbr7_I9OleRfGZvunpUYEl6TTAfVpZE6VpLyinOer
 0MxgY1nFOJ2aUXqU8dBbi.fsQlXjMLerW828MPkdXN4WocRIknzvdBIsNitH
 DMKfRYpOwE9w-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 6 Dec 2010 09:52:19 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [rfc: cpuops adv V1 0/8] Cmpxchg and xchg support for cpu ops
In-Reply-To: <4CFA970D.1080400@kernel.org>
Message-ID: <alpine.DEB.2.00.1012060951200.32000@router.home>
References: <20101202215340.562309713@linux.com> <4CFA9685.20200@cs.helsinki.fi> <4CFA970D.1080400@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Dec 2010, Tejun Heo wrote:

> I'll be happy to apply the per-cpu ops part.  Christoph, would it be
> okay to apply patches from this posting?

No. Please focus merging efforts on the cpu ops updates patchset. There is
a reason that there is an "rfc" in the title of this patchset (cpu ops
avanced).


