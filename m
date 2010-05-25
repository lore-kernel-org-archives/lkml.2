Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab0EYNff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:35:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57936 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab0EYNfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:35:33 -0400
Subject: Re: [PATCH] perf_events: fix event scheduling issues introduced by
 transactional API (take 2)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, acme@infradead.org,
       ming.m.lin@intel.com, perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <4bfbceef.e495e30a.5dae.61b6@mx.google.com>
References: <4bfbceef.e495e30a.5dae.61b6@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 May 2010 15:35:18 +0200
Message-ID: <1274794518.5882.1280.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 15:20 +0200, Stephane Eranian wrote:

> With this patch, you can now overcommit the PMU even with pinned
> system-wide events present and still get valid counts.

Does this patch differ from the one you send earlier?
