Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab2F0J7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:59:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:49302 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab2F0J7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:59:35 -0400
Message-ID: <1340791167.10063.7.camel@twins>
Subject: Re: [PATCH 4/4] perf, x86: Improve debug output in check_hw_exists()
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 27 Jun 2012 11:59:27 +0200
In-Reply-To: <20120622163643.GK24632@erda.amd.com>
References: <1340217996-2254-1-git-send-email-robert.richter@amd.com>
	 <1340217996-2254-5-git-send-email-robert.richter@amd.com>
	 <1340380427.18025.84.camel@twins> <20120622163643.GK24632@erda.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 18:36 +0200, Robert Richter wrote:
> I wonder why my gcc this didn't report, its 4.4.5.

gcc (Ubuntu/Linaro 4.6.1-9ubuntu3) 4.6.1

so you're like 2 minors behind. Time to update! ;-)
