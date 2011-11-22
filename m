Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab1KVSTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 13:19:34 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49688 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab1KVSTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 13:19:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAFPAmTRK6OubP5u_YwcRyyN6vujgqwBaq8-JobdnnYmjEE3Y+g@mail.gmail.com>
References: <1321181347-4391-1-git-send-email-consul.kautuk@gmail.com>
	<CAFPAmTRK6OubP5u_YwcRyyN6vujgqwBaq8-JobdnnYmjEE3Y+g@mail.gmail.com>
Date: Tue, 22 Nov 2011 13:19:32 -0500
Message-ID: <CAFPAmTSnUzdVagN6LzdsUnk1x-vTM3d5iE3aZd4HHQk=bhr7vw@mail.gmail.com>
Subject: Re: [PATCH 1/1 v4] arm: fault.c: Port OOM changes into do_page_fault
From: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got some time to do some more self-review and I spotted one
redundant piece of code in this patch
related to VM_FAULT_ERROR handling.

So I have resent as version 5.

Uh.. is there something fundamentally wrong with this patch ?
