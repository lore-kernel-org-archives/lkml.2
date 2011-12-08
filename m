Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab1LHVJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 16:09:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40056 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1LHVJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 16:09:03 -0500
Date: Thu, 8 Dec 2011 13:09:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Petr Holasek <pholasek@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH v3] NUMA x86: add constraints check for nid parameters
In-Reply-To: <20111208121640.GA2229@dhcp-27-244.brq.redhat.com>
Message-ID: <alpine.DEB.2.00.1112081308430.8127@chino.kir.corp.google.com>
References: <1322739907-4695-1-git-send-email-pholasek@redhat.com> <20111201133451.5fc1ee7b.akpm@linux-foundation.org> <20111201231441.GA3293@stainedmachine.redhat.com> <20111201152851.7e39f034.akpm@linux-foundation.org> <20111202105538.GB2188@dhcp-27-244.brq.redhat.com>
 <alpine.DEB.2.00.1112061233330.28251@chino.kir.corp.google.com> <20111207194311.GB26060@dhcp-27-244.brq.redhat.com> <alpine.DEB.2.00.1112071342450.27360@chino.kir.corp.google.com> <20111208121640.GA2229@dhcp-27-244.brq.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Dec 2011, Petr Holasek wrote:

> This patch adds constraints checks for numa_set_distance()
> function. It emits warning and avoids a store to a negative
> index in numa_distance[] array. Negative ids can be passed when
> pxm-to-nids mapping is not properly filled while parsing the SRAT.
> 
> Signed-off-by: Petr Holasek <pholasek@redhat.com>

Acked-by: David Rientjes <rientjes@google.com>

Thanks Petr!
