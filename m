Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab0IXRax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 13:30:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36549 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318Ab0IXRaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 13:30:52 -0400
Message-ID: <4C9CE01D.1060204@zytor.com>
Date: Fri, 24 Sep 2010 10:30:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] jump label: x86 support
References: <f838f49f40fbea0254036194be66dc48b598dcea.1284733808.git.jbaron@redhat.com> <tip-d9f5ab7b1c0a520867af389bab5d5fcdbd0e407e@git.kernel.org> <4C9CCF98.7000506@zytor.com> <20100924163435.GE2887@redhat.com>
In-Reply-To: <20100924163435.GE2887@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2010 09:34 AM, Jason Baron wrote:
> 
> The !CC_OPTIMIZE_FOR_SIZE condition is subsequently removed by a
> follow-on patch as part of the commit series.
> 

Ah, okay.  No problem then.

	-hpa
