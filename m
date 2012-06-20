Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab2FTUJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 16:09:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44062 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab2FTUJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 16:09:43 -0400
Message-ID: <1340222976.21745.125.camel@twins>
Subject: Re: [PATCH 0/4] perf, x86: Updates and cleanups
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 20 Jun 2012 22:09:36 +0200
In-Reply-To: <1340217996-2254-1-git-send-email-robert.richter@amd.com>
References: <1340217996-2254-1-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 20:46 +0200, Robert Richter wrote:
> I separated these for patches from my original NB counter
> implementation. They are independent and contain updates and
> cleanups. The most important change is the pmu unification. That code
> also changes pmu setup for core perfctr from family detection to cpuid
> check.

Thanks Robert!
