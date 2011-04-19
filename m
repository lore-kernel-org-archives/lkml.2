Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab1DSVSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:18:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:57941 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab1DSVSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:18:21 -0400
Subject: Re: [BUG] perf_event: sampling buffer format cannot handle
 multi-event sampling
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, mingo@elte.hu,
        Paul Mackerras <paulus@samba.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <BANLkTi=GX3JGw-Dq+ejsCguV0A+9w2eCjQ@mail.gmail.com>
References: <BANLkTi=g6iPgdctAmuZ=bb8J6FqNJA-vZQ@mail.gmail.com>
	 <1303240935.8345.7.camel@twins>
	 <BANLkTi=GX3JGw-Dq+ejsCguV0A+9w2eCjQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 23:20:56 +0200
Message-ID: <1303248056.2035.66.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 21:16 +0000, Stephane Eranian wrote:
> > Or simply don't mix different sample_types in the same buffer?
> >
> Does the kernel disallow this when you merge the output via that
> ioctl()? 

No, it will happily comply and provide you with hard to parse output.
Just don't do that if you're not willing to untangle it ;-)

