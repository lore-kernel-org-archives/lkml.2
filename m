Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab2BIIMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 03:12:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975Ab2BIIMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 03:12:48 -0500
Date: Thu, 9 Feb 2012 00:13:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH v8 4/8] smp: add func to IPI cpus based on parameter
 func
Message-Id: <20120209001335.49f2360b.akpm@linux-foundation.org>
In-Reply-To: <CAOtvUMebLNtMcrxuxRq_U5UbwNt-9mE0-0z7Zg79abRTbHE4MQ@mail.gmail.com>
References: <1328448800-15794-1-git-send-email-gilad@benyossef.com>
	<1328449722-15959-3-git-send-email-gilad@benyossef.com>
	<op.v9csppvv3l0zgt@mpn-glaptop>
	<20120208160344.88d187e5.akpm@linux-foundation.org>
	<CAOtvUMebLNtMcrxuxRq_U5UbwNt-9mE0-0z7Zg79abRTbHE4MQ@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Feb 2012 10:08:16 +0200 Gilad Ben-Yossef <gilad@benyossef.com> wrote:

> BTW -  I used a macro since I imitated the rest of the code in smp.h
> but is there any
> reason not to use an inline macro here?

If it can be implemented in C then sure, go for it - that's superior in
numerous ways.

