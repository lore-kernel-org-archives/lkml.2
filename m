Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1GUMg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 08:36:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37101 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab1GUMgx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 08:36:53 -0400
Subject: Re: [PATCH 3/6] x86: Allow the user not to build hw_breakpoints
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110721072656.GF9216@elte.hu>
References: <1310655837-328-1-git-send-email-fweisbec@gmail.com>
	 <1310655837-328-4-git-send-email-fweisbec@gmail.com>
	 <4E1F5EF3.6050601@zytor.com>  <20110721072656.GF9216@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Jul 2011 14:36:25 +0200
Message-ID: <1311251785.29152.141.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-21 at 09:26 +0200, Ingo Molnar wrote:
> Otherwise we have expressed hw breakpoint APIs via perf events and 
> that model is working well. 

Its working, maybe, working well is pushing it. The whole breakpoint
muck is a horrid mess, it side-steps all of the resource scheduling
stuff of perf and does it itself.

Now part of that is because ptrace requires it, but whichever way you
look at it its damn ugly.
