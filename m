Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab0IWMms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 08:42:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60111 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab0IWMmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 08:42:46 -0400
X-Authority-Analysis: v=1.1 cv=Yii9LXZpONf3Dl4H+sCjsa4WyoNNo7yi1hAau1xJxWE= c=1 sm=0 a=B18Bxh7V_foA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=CuqcJgowh1kHfjdQLEgA:9 a=vR9_7nFc3JC8mu6mD0F7zYuySKwA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [GIT PULL] jump label: add jump label code
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
        David Miller <davem@davemloft.net>
In-Reply-To: <20100923034910.867858597@goodmis.org>
References: <20100923034910.867858597@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 23 Sep 2010 08:42:41 -0400
Message-ID: <1285245761.26872.1169.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 23:49 -0400, Steven Rostedt wrote:

> Jason Baron (8):
>       jump label: Make dynamic no-op selection available outside of ftrace
>       jump label: Make text_poke_early() globally visible
>       jump label: Base patch for jump label
>       jump label: Initialize workqueue tracepoints *before* they are registered
>       jump label: Add jump_label_text_reserved() to reserve jump points
>       jump label: Tracepoint support for jump labels
>       jump label: Convert dynamic debug to use jump labels
>       jump label: x86 support

Jason,

If you noticed, I left out your last patch: the documentation one. I did
this because there was enough comments to require a resubmit. Could you
just send that one patch, with the corrections, by itself?

Thanks,

-- Steve

