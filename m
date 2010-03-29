Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab0C2HrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 03:47:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49124 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab0C2Hq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 03:46:59 -0400
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH] Allow Intel platforms to declare unsynchronized TSC to kernel
From: Andi Kleen <andi@firstfloor.org>
References: <20100324053257.GA4088@basil.fritz.box>
Date: Mon, 29 Mar 2010 09:46:58 +0200
In-Reply-To: <20100324053257.GA4088@basil.fritz.box> (Andi Kleen's message of "Wed, 24 Mar 2010 06:32:57 +0100")
Message-ID: <87zl1r7eod.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Allow Intel platforms to declare unsynchronized TSC to kernel
>
> [This came out of a private discussion with Linus last week]

Ping?  Please review this patch.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
