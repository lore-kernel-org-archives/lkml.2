Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360Ab2AGBOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 20:14:52 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43998 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759252Ab2AGBOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 20:14:51 -0500
MIME-Version: 1.0
In-Reply-To: <20120106124649.146001d6@jbarnes-desktop>
References: <20111217092935.2c2e075e@jbarnes-desktop>
	<CAE9FiQWueS=9aSAH4fLz=EpE=A_WanKU6pbfnR2a4gsymWjnDA@mail.gmail.com>
	<dfbb748b-b9de-4390-bb8d-138fc4c5734f@email.android.com>
	<CA+55aFz7j8ipEn7e0dGnrG4dskyRiBOx0-ExAx3qnH_cR5mLQw@mail.gmail.com>
	<20120106124649.146001d6@jbarnes-desktop>
Date: Fri, 6 Jan 2012 17:14:50 -0800
X-Google-Sender-Auth: fXVNqj3HVvGOTublFIcY3i41594
Message-ID: <CAE9FiQV6KegN97Ue1obDb5EJohvK_Mg_ktxJN4uPN3bRrLGh5A@mail.gmail.com>
Subject: Re: [git pull] PCI fixes
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 6, 2012 at 12:46 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> There was some talk awhile back of pulling the SR-IOV resources out of
> the pci_dev resource array (adding a separate member to track them only
> if CONFIG_PCI_IOV is enabled), that would probably be the way to go.
> Then fix up whatever resource walking code that cares about IOV BARs
> (there isn't much I think).
>
> Any thoughts Yinghai?

We can add helpers like
for_each_resource_for_dev()
for_each_resource_for_dev_bridge()

Thanks

Yinghai
