Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab0LGOq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:46:58 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:44646 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751412Ab0LGOq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:46:57 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: x3mqFyUVM1lJCPIzvoyyu0bclmzrKnA8jXXLxSrMk3Ybr7I
 n_WwqJQS0XmpNZZYFXhOwW3SknZa9lVhumj0Ztm.8OSUf2vYQZIaZlrX155f
 lud53ADoGvxF5Z88tCK61XpJGESc_2oczJgFs0s._oNMewSuS9Asozy2hFJs
 rWDl6xFq_.jIzwAPPcrjDipRtlrSfBHG8TAcF9XZttaU9jNXZcjEBogKqFUy
 PA5NDRAqQqwI-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 7 Dec 2010 08:46:52 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [Use cpuops V1 04/11] x86: Use this_cpu_ops for current_cpu_data
 accesses
In-Reply-To: <4CFE4294.30001@kernel.org>
Message-ID: <alpine.DEB.2.00.1012070846050.25976@router.home>
References: <20101206171618.302060721@linux.com> <20101206171638.595205962@linux.com> <4CFE41F8.7040400@kernel.org> <4CFE4294.30001@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010, Tejun Heo wrote:

> > This belongs to the previous patch, right?  I'll move it over and
> > apply 03 and 04.  I think routing these through percpu is okay but if
> > anyone wants these to go through x86, scream.
>
> Ooh, was too fast.  I think mixing the use of percpu accesses to
> cpu_info and the wrapper macro current_cpu_data is quite confusing.
> There aren't too many current_cpu_data users in x86 anyway.  Can you
> please make the conversion complete?  I'm moving the above misplaced
> chunk into 03 and not applying 04 for now.

We cannot make that conversion complete since we cannot obtain the address
if we use a this_cpu operation. Then its better to drop this patch.

