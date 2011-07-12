Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab1GLIiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 04:38:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:45332 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab1GLIip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 04:38:45 -0400
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>
In-Reply-To: <4E1BF5A1.5070301@redhat.com>
References: <1309362157-6596-1-git-send-email-avi@redhat.com>
	 <1309362157-6596-2-git-send-email-avi@redhat.com>
	 <20110629160841.GA2032@somewhere>
	 <20110629162725.GH15521@e102144-lin.cambridge.arm.com>
	 <20110704135820.GD5551@somewhere> <4E11C9CC.2070909@redhat.com>
	 <20110704143655.GE5551@somewhere>
	 <20110711210753.GA3582@e102144-lin.cambridge.arm.com>
	 <4E1BF5A1.5070301@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 12 Jul 2011 10:38:18 +0200
Message-ID: <1310459898.18678.108.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-12 at 10:20 +0300, Avi Kivity wrote:

> Maybe we need a generic "run this function in this task's context" 
> mechanism instead.  Like an IPI, but targeting tasks instead of cpus.
> 

kernel/event/core.c:task_function_call() like?
