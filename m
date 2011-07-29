Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab1G2RDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 13:03:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:41050 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab1G2RDK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 13:03:10 -0400
Subject: Re: [PATCH 7/7] perf, x86: Implement 64 bit counter support for IBS
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1311958728.5890.412.camel@twins>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
	 <1311860812-28748-8-git-send-email-robert.richter@amd.com>
	 <1311958728.5890.412.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 29 Jul 2011 19:02:42 +0200
Message-ID: <1311958962.5890.416.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 18:58 +0200, Peter Zijlstra wrote:
> On Thu, 2011-07-28 at 15:46 +0200, Robert Richter wrote:
> > This patch implements 64 bit counter support for IBS. The sampling
> > period is no longer limited to the hw counter width.
> 
> That should never be the case, even for shorter hw counter, in such a
> case you should ignore overflows until you reach the programmed period.

Hmm, I might have mis-understood, is that exactly what this patch
implements, or does this patch add support for new hardware?


