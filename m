Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab2FPMwi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 08:52:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47027 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2FPMwh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 08:52:37 -0400
Message-ID: <1339851149.15222.10.camel@twins>
Subject: Re: [PATCH V6 06/13] perf: Add Nehalem and Sandy Bridge uncore
 support
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Date: Sat, 16 Jun 2012 14:52:29 +0200
In-Reply-To: <1339850780.15222.8.camel@twins>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
	 <1339741902-8449-7-git-send-email-zheng.z.yan@intel.com>
	 <1339780730.2559.92.camel@twins>
	 <CABPqkBTuBnFWo0wpcmg_YR_C0Q_BAMBqs7nrFTHnag=_RMPddA@mail.gmail.com>
	 <1339850780.15222.8.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-16 at 14:46 +0200, Peter Zijlstra wrote:
> Right, I did the below on top..

I also did a s/cbo[^x]/cbox/ and s/(u64)-1/~0ULL/ on the entire
patch-set.
