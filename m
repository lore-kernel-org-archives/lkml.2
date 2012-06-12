Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab2FLTdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 15:33:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38136 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2FLTdv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 15:33:51 -0400
Message-ID: <1339529614.31548.104.camel@twins>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, "Yu, Fenghua" <fenghua.yu@intel.com>
Date: Tue, 12 Jun 2012 21:33:34 +0200
In-Reply-To: <20120612190720.GA11137@aftab.osrc.amd.com>
References: <20120607071531.GA4849@quad> <4FD78BE6.4060207@zytor.com>
	 <20120612190720.GA11137@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 21:07 +0200, Borislav Petkov wrote:
> Nice, this is the initrd cpio thing, cool, no changes needed for the
> bootloader. Ping me when you have something ready so that I can start
> testing it here too. 

What do people like me do that don't use initrd like nonsense?

