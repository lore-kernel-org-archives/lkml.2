Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab1KJMwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 07:52:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42891 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab1KJMwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 07:52:21 -0500
Subject: Re: [V2][PATCH 5/5] oprofile, x86: Reimplement nmi timer mode using
 perf event
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Date: Thu, 10 Nov 2011 13:52:05 +0100
In-Reply-To: <20111023112728.GB5156@elte.hu>
References: <1319050075-23901-1-git-send-email-robert.richter@amd.com>
	 <1319050075-23901-6-git-send-email-robert.richter@amd.com>
	 <20111023112728.GB5156@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320929525.13800.13.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-23 at 13:27 +0200, Ingo Molnar wrote:
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> > The legacy x86 nmi watchdog code was removed with the implementation
> > of the perf based nmi watchdog. This broke Oprofile's nmi timer
> > mode. To run nmi timer mode we relied on a continuous ticking nmi
> > source which the nmi watchdog provided. The nmi tick was no longer
> > available and current watchdog can not be used anymore since it runs
> > with very long periods in the range of seconds. This patch
> > reimplements the nmi timer mode using a perf counter nmi source.
> > 

> Looks clean to me. Peter, any objections?

No.
