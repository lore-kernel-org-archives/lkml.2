Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab0LMKLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 05:11:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab0LMKLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 05:11:40 -0500
Date: Mon, 13 Dec 2010 12:10:48 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        kvm <kvm@vger.kernel.org>, Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 0/4] KVM & genirq: Enable adaptive IRQ sharing for
 passed-through devices
Message-ID: <20101213101048.GE25590@redhat.com>
References: <cover.1292152963.git.jan.kiszka@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1292152963.git.jan.kiszka@web.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 12:22:40PM +0100, Jan Kiszka wrote:
> The result may look simpler on first glance than v1, but it comes with
> more subtle race scenarios IMO. I thought them through, hopefully
> catching all, but I would appreciate any skeptical review.

Thought about the races till my head hurt, and yes, they
all seem to be handled correctly. FWIW

Reviewed-by: Michael S. Tsirkin <mst@redhat.com>

