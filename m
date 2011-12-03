Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272Ab1LCGBf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 01:01:35 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47339 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab1LCGBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 01:01:31 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.53.1]
In-Reply-To: <1322867384.11728.20.camel@pasglop>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com> <1322867384.11728.20.camel@pasglop>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 3 Dec 2011 08:01:09 +0200
Message-ID: <CAK=WgbYgbShjuFozOQh5Zk+Dh7jymrvtSiVFHzDLB4Nk0zMNaw@mail.gmail.com>
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 3, 2011 at 1:09 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> Have you measured the impact of using normal barriers (non-SMP ones)
> like we use on normal HW drivers unconditionally ?
>
> IE. If the difference is small enough I'd say just go for it and avoid
> the bloat.

I agree.

MST wanted to give this a try this week. If all goes well and there's
no unreasonable regression, we'd just switch to mandatory barriers.

Ohad.
