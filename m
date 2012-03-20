Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996Ab2CTNtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:49:25 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36520 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759845Ab2CTNtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:49:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvyVbDndbu_2ZbUBwbrJCq+d4rRZW0ROxTpQxAvetRm=0w@mail.gmail.com>
References: <CAFPAmTQs9dOpQTaXU=6Or66YU+my_CnPw33TE4h++YArBNa38g@mail.gmail.com>
	<CAFLxGvwW2XcYSoidZZ0XF_a-pH3SwONqS+hCnpGUecQ__DLa_g@mail.gmail.com>
	<CAFPAmTSzV9mrkbP68p4PA-0i0o2Hz7JiBY=0A0V_myJEzWubjQ@mail.gmail.com>
	<CAFLxGvyVbDndbu_2ZbUBwbrJCq+d4rRZW0ROxTpQxAvetRm=0w@mail.gmail.com>
Date: Tue, 20 Mar 2012 09:49:22 -0400
Message-ID: <CAFPAmTQxKhmmEaaCEL6bCsKartfOhgmTn5gTLEB+_QzW6O2RjQ@mail.gmail.com>
Subject: Re: [PATCH 0/20] mmu: arch/mm: Port OOM changes to arch page fault handlers.
From: Kautuk Consul <consul.kautuk@gmail.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No problem.
> handle_page_fault() is the function you want to patch. :)
>

Sent.
Terribly sorry for the miss.

Also, the UML page fault handler has some differences from the other
page fault handlers,
so I apologize if I have made some wrong assumptions or mistakes.


> --
> Thanks,
> //richard
