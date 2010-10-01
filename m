Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab0JADdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 23:33:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751769Ab0JADdX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 23:33:23 -0400
MIME-Version: 1.0
In-Reply-To: <20100930221351.682772535@linutronix.de>
References: <20100930221351.682772535@linutronix.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 30 Sep 2010 20:32:26 -0700
Message-ID: <AANLkTin1titZ1vjGLhBn8CY0CjZDj332zM8DW1JHv7Cx@mail.gmail.com>
Subject: Re: [patch 00/47] Sparse irq rework
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 4:14 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> The overall changes are (full changelog below):
>    56 files changed, 1229 insertions(+), 1682 deletions(-)

I can't really argue with those numbers. And the patches I looked at
(which was not all of them, but maybe half) looked reasonable.

Assuming it all _works_ ...

                Linus
