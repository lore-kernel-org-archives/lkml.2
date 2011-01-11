Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab1AKAyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 19:54:35 -0500
Received: from adelie.canonical.com ([91.189.90.139]:42410 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab1AKAye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 19:54:34 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/2] Add a common struct clk
Date: Tue, 11 Jan 2011 08:54:15 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; x86_64; ; )
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Ben Herrenchmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
References: <1294199462.347935.472473715866.0.gpush@pororo> <20110110104122.GI12078@pengutronix.de> <20110110110028.GB12552@n2100.arm.linux.org.uk>
In-Reply-To: <20110110110028.GB12552@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101110854.15653.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

> Unless the locking problems can be resolved, the patches aren't ready.
> 
> From what I've seen there's still quite a problem with what kind of
> lock to use in the clock - mutex or spinlock.

Yes, the clock driver may either use a spinlock or mutex.

However, this exactly the same as the current clock code, my patches do not 
alter what we currently have.

I do agree that we should define some specific semantics for the clock API 
with regards to sleeping, and I'll start a new thread about that. But we 
should definitely separate that issue from the problem of having multiple 
definitions for struct clk, which is what these patches address.

Cheers,


Jeremy
