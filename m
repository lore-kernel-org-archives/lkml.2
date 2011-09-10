Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab1IJCvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 22:51:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751924Ab1IJCvO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 22:51:14 -0400
MIME-Version: 1.0
In-Reply-To: <20110910005922.GA5293@myri.com>
References: <1315518078-30619-2-git-send-email-mason@myri.com>
 <CA+55aFxhb1f6X4GO=+ZK1AUtmApPnLSP=JYGktQe1jsL7onX7A@mail.gmail.com> <20110910005922.GA5293@myri.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Sep 2011 19:50:18 -0700
Message-ID: <CA+55aFzH4u11t5b8AWJoYbJS+18U5fzGoH17tv9UTDfC3WHhPA@mail.gmail.com>
Subject: Re: [PATCH 1/2] Fix pointer dereference before call to pcie_bus_configure_settings
To: Jon Mason <mason@myri.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Shyam Iyer <shyam.iyer.t@gmail.com>,
        Shyam Iyer <shyam_iyer@dell.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 9, 2011 at 5:59 PM, Jon Mason <mason@myri.com> wrote:
>
> There is a potential NULL pointer dereference in calls to
> pcie_bus_configure_settings due to attempts to access pci_bus self
> variables when the self pointer is NULL.  To correct this, verify that
> the self pointer in pci_bus is non-NULL before dereferencing it.

Thanks,

               Linus
