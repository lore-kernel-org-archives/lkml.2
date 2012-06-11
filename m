Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab2FKIQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:16:42 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41715 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab2FKIQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:16:40 -0400
Date: Mon, 11 Jun 2012 10:16:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: eranian@google.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] perf, x86: Add basic Ivy Bridge support v2
Message-ID: <20120611081634.GA31556@gmail.com>
References: <1339191928-13223-1-git-send-email-andi@firstfloor.org>
 <1339191928-13223-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339191928-13223-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> +	char *name;
> +		name = "Ivy";
> +		name = "Sandy";
> -		pr_cont("SandyBridge events, ");
> +		pr_cont("%sBridge events, ", name);

Second round review feedback: you'll have to remove this ugly 
obfuscation, the kernel is already complex as-is. In performance 
insensitive code paths we want straight, obvious code without 
tricks.

Please resubmit the patches with this fixed.

Thanks,

	Ingo
