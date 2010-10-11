Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab0JKRFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 13:05:40 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:54276 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755628Ab0JKRFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 13:05:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cocdj1h5fTZSbxavo6eKF+vV3QmXHsXnSaWZv4MEoX+Spok/Ql3LGicAzB0Hjurcsy+zuUyq4KkDluelubwYeLimno7SqCiUZvh2nFqIW/aL6Q3XLwh0uZTBjpbOs4we;
Date: Mon, 11 Oct 2010 10:08:49 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 33/47] pci: Cleanup the irq_desc mess in msi
Message-ID: <20101011100849.072b9ba6@jbarnes-desktop>
In-Reply-To: <20100930221741.720879189@linutronix.de>
References: <20100930221351.682772535@linutronix.de>
	<20100930221741.720879189@linutronix.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010 23:17:18 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> Handing down irq_desc to msi just so that msi can access
> irq_desc.irq_data.msi_desc is a pretty stupid idea. The calling code
> can hand down a pointer to msi_desc so msi code does not need to know
> about the irq descriptor at all.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---

Looks like a good cleanup.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
