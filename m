Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab1LJVrE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 16:47:04 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35502 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab1LJVrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 16:47:01 -0500
Date: Sat, 10 Dec 2011 21:46:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Heechul Yun <heechul@illinois.edu>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/62] arm: remove the second argument of
	k[un]map_atomic()
Message-ID: <20111210214645.GQ14542@n2100.arm.linux.org.uk>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com> <1322371662-26166-4-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322371662-26166-4-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 01:26:43PM +0800, Cong Wang wrote:
> 
> Signed-off-by: Cong Wang <amwang@redhat.com>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks for doing this.
