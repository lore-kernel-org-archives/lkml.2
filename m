Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760542Ab2FGN2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:28:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55736 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab2FGN2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:28:02 -0400
Date: Thu, 7 Jun 2012 15:28:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
Message-ID: <20120607132801.GL27374@one.firstfloor.org>
References: <20120607071531.GA4849@quad> <1339064319.23343.13.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339064319.23343.13.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This will only warn about the PEBS issue once you try and use a PEBS
> counter. Shouldn't we do this on boot? IOW. put check_pebs_quirks()

At boot the new microcode may not be loaded yet. So you have to delay
the check.

-Andi
