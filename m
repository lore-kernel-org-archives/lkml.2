Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab1BYU6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:58:09 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:40999 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751227Ab1BYU6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:58:07 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: VkvYKZoVM1l5cIjZehq6bD6_ebvXfCaTbjCyF.hk6RZOTTP
 Cbqooe.nKXibXRjJEQAoHCQvwwH3NTNKKZg_ffbCqG5GqWNud2HwAKzEK9K0
 QKcsAPRBwx6eeIQjnUl0UVUkYKgyHT.OSQBrAm8z8biPUsi.uFRH7Rn.W5bc
 ITkRflXv4C2ULvaK9S4W2YF2RE2rkU9Z0zHuDB8AD22FaKk5ns4uwBh5FcWz
 tDClmk239O5sosUGi4SHZ6PoXugzjPq45nwWJ9RiQmBMtfieoSs0Pxp8RGfE
 Ft3yKeomSxFyWMAdyZUxWxFNZGHq7hK5PKWpWPZJncB6CT.4-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 25 Feb 2011 14:58:02 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Steven Rostedt <rostedt@goodmis.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V3 3/5] Generic support for
 this_cpu_cmpxchg_double
In-Reply-To: <1298667222.6376.23.camel@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.1102251457160.7359@router.home>
References: <20110225173850.486326452@linux.com>  <20110225174155.786331687@linux.com>  <20110225202837.GC23161@home.goodmis.org>  <alpine.DEB.2.00.1102251443500.7359@router.home> <1298667222.6376.23.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011, Steven Rostedt wrote:

> I was thinking that if these are per_cpu then they would be global and
> thus constant. But those are done at link time, which is too late.

Well per_cpu data can also be dynamically allocated via alloc_percpu.
Which is the use case here.

