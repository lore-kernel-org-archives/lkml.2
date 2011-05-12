Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab1ELIvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 04:51:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46268 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab1ELIvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 04:51:46 -0400
Subject: Re: [RFC PATCH] perf: Carve out cgroup-related code
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1305190277.2914.259.camel@laptop>
References: <20110511121135.GA25865@aftab>
	 <1305121600.2914.214.camel@laptop> <20110511140208.GD25827@aftab>
	 <20110511141342.GA19053@elte.hu> <20110511143149.GA26548@aftab>
	 <20110511152156.GA21707@elte.hu>  <20110511170912.GA27362@aftab>
	 <1305190277.2914.259.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 10:54:49 +0200
Message-ID: <1305190489.2914.260.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 10:51 +0200, Peter Zijlstra wrote:
> On Wed, 2011-05-11 at 19:09 +0200, Borislav Petkov wrote:

Also please don't cross-post to bouncy lists like this weird amd list
you included.

