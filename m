Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab0DGQyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 12:54:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:33816 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab0DGQyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:54:07 -0400
Subject: Re: [PATCH] perf_events: add PERF_SAMPLE_BRANCH_STACK
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <l2kbd4cb8901004070948zcc0fd6dcv8eb2431edd271c4e@mail.gmail.com>
References: <4bbc7fcf.100db80a.6b9f.fffffb14@mx.google.com>
	 <1270646127.20295.976.camel@laptop>
	 <l2kbd4cb8901004070948zcc0fd6dcv8eb2431edd271c4e@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 18:54:03 +0200
Message-ID: <1270659243.20295.1011.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-07 at 18:48 +0200, Stephane Eranian wrote:
> Then, why didn't you extend perf to leverage your patch?
> 
Because I couldn't come up with a sensible use case.

