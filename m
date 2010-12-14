Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab0LNWB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 17:01:29 -0500
Received: from www.tglx.de ([62.245.132.106]:35553 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758055Ab0LNWB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 17:01:27 -0500
Date: Tue, 14 Dec 2010 23:01:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@web.de>
cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 0/4] KVM & genirq: Enable adaptive IRQ sharing for
 passed-through devices
In-Reply-To: <cover.1292281184.git.jan.kiszka@web.de>
Message-ID: <alpine.LFD.2.00.1012142259360.12146@localhost6.localdomain6>
References: <cover.1292281184.git.jan.kiszka@web.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Dec 2010, Jan Kiszka wrote:

> This addresses the review comments of the previous round:
>  - renamed irq_data::status to drv_status
>  - moved drv_status around to unbreak GENERIC_HARDIRQS_NO_DEPRECATED
>  - fixed signature of get_irq_status (irq is now unsigned int)
>  - converted register_lock into a global one
>  - fixed critical white space breakage (that I just left in to check if
>    anyone is actually reading the code, of course...)

Just for the record, you either missed or introduced some new white
space noise :)
