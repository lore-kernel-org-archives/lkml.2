Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab0G1Qta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:49:30 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57425 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717Ab0G1Qt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:49:26 -0400
Message-ID: <4C505F86.7050509@cs.helsinki.fi>
Date: Wed, 28 Jul 2010 19:49:10 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Daniel J Blueman <daniel.blueman@gmail.com>
CC: Catalin Marinas <catalin.marinas@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.35-rc6 patch] increase kmemleak robustness at boot
References: <AANLkTin-9jtHP1xmhUp4uUQNZD64pN3Ee5Kn2cqH64Go@mail.gmail.com>
In-Reply-To: <AANLkTin-9jtHP1xmhUp4uUQNZD64pN3Ee5Kn2cqH64Go@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel J Blueman wrote:
> I've consistently been experiencing kmemleak exhaust it's 400-entry
> early-boot buffer and disabling itself; there have been reports of
> this also, and I'm finding this on x86-64 with various debug options
> enabled.
> 
> If we issue a warning and allow the buffer to wrap, we don't need to
> hit the kill-switch. While we lose track of some early potential
> leaks, it's better than no functionality.
> 
> Let me know if it's acceptable, and many thanks for such an excellent tool,

Is it just potential leaks that we lose or can this cause false positives?
