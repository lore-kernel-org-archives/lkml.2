Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab0KZL2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:28:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:36769 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab0KZL2x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:28:53 -0500
Subject: Re: [PATCH 1/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        Paul Menage <menage@google.com>, Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <4CEF6FC2.4040806@cn.fujitsu.com>
References: <4ce510d4.0fedd80a.742c.10b9@mx.google.com>
	 <1290684523.2145.31.camel@laptop> <4CEF1260.4000009@cn.fujitsu.com>
	 <20101126025605.GF3298@balbir.in.ibm.com> <4CEF6FC2.4040806@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 26 Nov 2010 12:28:54 +0100
Message-ID: <1290770934.2145.129.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 16:28 +0800, Li Zefan wrote:
> More information:
> 
> Another feature recently added (eventfd-based notifications) also uses fd
> to identify a cgroup. 

Ok, anyway I guess this all means the cgroup people are fine with
this ;-)
