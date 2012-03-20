Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967Ab2CTNer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:34:47 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34156 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759463Ab2CTNem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:34:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvwW2XcYSoidZZ0XF_a-pH3SwONqS+hCnpGUecQ__DLa_g@mail.gmail.com>
References: <CAFPAmTQs9dOpQTaXU=6Or66YU+my_CnPw33TE4h++YArBNa38g@mail.gmail.com>
	<CAFLxGvwW2XcYSoidZZ0XF_a-pH3SwONqS+hCnpGUecQ__DLa_g@mail.gmail.com>
Date: Tue, 20 Mar 2012 09:34:41 -0400
Message-ID: <CAFPAmTSzV9mrkbP68p4PA-0i0o2Hz7JiBY=0A0V_myJEzWubjQ@mail.gmail.com>
Subject: Re: [PATCH 0/20] mmu: arch/mm: Port OOM changes to arch page fault handlers.
From: Kautuk Consul <consul.kautuk@gmail.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: linux-alpha@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux@openrisc.net, linux-am33-list@redhat.com,
        microblaze-uclinux@itee.uq.edu.au, linux-m68k@vger.kernel.org,
        linux-m32r-ja@ml.linux-m32r.org, linux-ia64@vger.kernel.org,
        linux-hexagon@vger.kernel.org, linux-cris-kernel@axis.com,
        linux-sh@vger.kernel.org, linux-parisc@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> What about arch/um/?
> Does UML not need this change?

Oh yes, extremely sorry I accidentally missed that one out.
Mind if I send it separately ?

>
> --
> Thanks,
> //richard
