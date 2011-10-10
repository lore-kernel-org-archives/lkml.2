Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab1JJJdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 05:33:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:52657 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab1JJJdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 05:33:38 -0400
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for
 Intel X86
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, acme@redhat.com, ming.m.lin@intel.com,
        robert.richter@amd.com, ravitillo@lbl.gov,
        "masami.hiramatsu.pt" <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
In-Reply-To: <20111010060810.GF32173@elte.hu>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	 <1317912555-9559-8-git-send-email-eranian@google.com>
	 <20111006153229.GJ14482@one.firstfloor.org>
	 <1317919424.29658.13.camel@twins>
	 <20111006171412.GK14482@one.firstfloor.org>
	 <20111010060810.GF32173@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 11:39:41 +0200
Message-ID: <1318239581.14400.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 08:08 +0200, Ingo Molnar wrote:
> FUD is not how we approach these things - you need to say something 
> specific. 

Its Andi, of course its FUD. I mean, he's been telling us to use IRQs
for the PMI instead of NMIs for a while now. If we were to do something
daft like that this whole feature, which he does like, would be
useless/broken.

He really can't seem to make up his mind.

