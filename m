Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab1LNRc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:32:59 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59303 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962Ab1LNRcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:32:55 -0500
Message-ID: <4EE8EB95.7040901@mvista.com>
Date: Wed, 14 Dec 2011 21:31:49 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: ralf@linux-mips.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mips@linux-mips.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Jason Baron <jbaron@redhat.com>, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] jump-label: initialize jump-label subsystem somewhat
 later
References: <1323881315-23245-1-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1323881315-23245-1-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/14/2011 07:48 PM, David Daney wrote:

> From: David Daney <david.daney@cavium.com>

> commit 97ce2c88f9ad42e3c60a9beb9fca87abf3639faa breaks MIPS.

    Please also specify that commit's summary (in parens).

> The jump-lable initialization does I-Cache flushing after modifying

    Label.

> code.  On MIPS this is done by calling through the function pointer
> flush_icache_range().  This function pointer is initialized mm_init().

    "By" missing?

> As things stand, we cannot be calling jump_label_init() until after
> mm_init() completes, so we move the call down to satisfy this
> constraint.

> Signed-off-by: David Daney<david.daney@cavium.com>

WBR, Sergei
