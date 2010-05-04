Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab0EDOSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:18:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39540 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab0EDOSX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:18:23 -0400
Subject: Re: [osrc-patches] [PATCH 00/12] perf: introduce model specific
 events and AMD IBS
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Stephane Eranian <eranian@google.com>
In-Reply-To: <20100428161659.GA20783@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
	 <20100428161659.GA20783@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 May 2010 16:18:15 +0200
Message-ID: <1272982695.5605.194.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-28 at 18:16 +0200, Robert Richter wrote:
> I suggest to apply patches 1, 2, 3, 5, 6 to tip/perf/core if you don't
> have objections. I will then resubmit a new version of all remaining
> patches. 

Ok, I'm not a big fan of 5, but I guess there's no way around that
without adding lots more code.


