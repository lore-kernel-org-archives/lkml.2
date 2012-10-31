Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab2JaHWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:22:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:41634 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447Ab2JaHWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:22:52 -0400
Message-ID: <1351668137.4047.38.camel@twins>
Subject: Re: [RFC][PATCH] perf: Add a few generic stalled-cycles events
From: Peter Zijlstra <peterz@infradead.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Robert Richter <robert.richter@amd.com>, acme@redhat.com, mingo@kernel.org,
        eranian@google.com, asharma@fb.com,
        Anton Blanchard <anton@au1.ibm.com>, paulus@samba.org,
        mpjohn@us.ibm.com, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Wed, 31 Oct 2012 08:22:17 +0100
In-Reply-To: <20121031064056.GA12061@us.ibm.com>
References: <20121012012839.GA15348@us.ibm.com>
	 <20121015155534.GR8285@erda.amd.com> <20121016100809.GS8285@erda.amd.com>
	 <20121016183148.GA25482@us.ibm.com> <1351081662.22332.13.camel@twins>
	 <20121031064056.GA12061@us.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 23:40 -0700, Sukadev Bhattiprolu wrote:
> So instead of the names I came up with in this patch, stalled-cycles-fixed-point
> we could use the name used in the CPU spec - 'cmplu_stall_fxu' in the arch
> specific code ? 

You could, but I would advise against it. Human readable names are so
much more accessible.
