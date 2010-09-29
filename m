Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab0I2PDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 11:03:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36074 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab0I2PC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 11:02:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hj3lUhlmfB6bsVSKD4nz0T3iQ/UK9zlUKmS0G3bPuEN7rFmr4I7qJrID++bpwqq27Y
         xWvwMd/irVYkeXC0BkuNdsNY8DNcKeopgDYly1THMi7lQrpTmFccuMqgQo3pfAGCEGEw
         Ov5/hFa4wEYJMRqGiYN/ow5UjViOuh881aAPE=
Date: Wed, 29 Sep 2010 19:02:54 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
	disabling counters
Message-ID: <20100929150253.GB9440@lenovo>
References: <20100915162034.GO13563@erda.amd.com> <tip-63e6be6d98e1a2bcdca86872b67052e51ab6afa1@git.kernel.org> <AANLkTimB2gf=2zYCwiKEgozt_Rsa1Cpb6JuLSzmHusFX@mail.gmail.com> <20100929125301.GG13563@erda.amd.com> <20100929125453.GH13563@erda.amd.com> <AANLkTimoE8wAhT+yxXBPnZvTTGrAtDjdaXPBN3Xg28eL@mail.gmail.com> <20100929133923.GI13563@erda.amd.com> <AANLkTin2QnqsfxdZa2D07DKCM0n5bX43Ch6KqumaDW=O@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin2QnqsfxdZa2D07DKCM0n5bX43Ch6KqumaDW=O@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 03:56:08PM +0200, Stephane Eranian wrote:
...
> Ok, I think we agree on this. It is handled in the Intel case, though it
> is not clearly explained with a comment.
> The P4 case needs to be fixed.
>

Seems so. Thanks Stephane. I'll check and fix as only be able to
(in a couple of hours).

  Cyrill
