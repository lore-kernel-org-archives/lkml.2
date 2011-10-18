Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab1JRLAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 07:00:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:41622 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab1JRLAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 07:00:00 -0400
Subject: Re: [PATCH 5/5] oprofile, x86: Reimplement nmi timer mode using perf
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Date: Tue, 18 Oct 2011 12:59:41 +0200
In-Reply-To: <1318861624-715-6-git-send-email-robert.richter@amd.com>
References: <1318861624-715-1-git-send-email-robert.richter@amd.com>
	 <1318861624-715-6-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318935581.21167.13.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 16:27 +0200, Robert Richter wrote:
> The legacy x86 nmi watchdog code was removed with the implementation
> of the perf based nmi watchdog. This broke Oprofile's nmi timer
> mode. To run nmi timer mode we relied on a continuous ticking nmi
> source which the nmi watchdog provided. The nmi tick was no longer
> available and current watchdog can not be used anymore since it runs
> with very long periods in the range of seconds. This patch
> reimplements the nmi timer mode using a perf counter nmi source.

fair enough,

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

I take it you'll take this through your oprofile tree?
