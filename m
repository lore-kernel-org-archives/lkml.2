Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab0LPWBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 17:01:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819Ab0LPWBA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 17:01:00 -0500
MIME-Version: 1.0
In-Reply-To: <20101216173614.8185.19462.stgit@bob.kio>
References: <20101216173614.8185.19462.stgit@bob.kio>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 16 Dec 2010 13:59:33 -0800
Message-ID: <AANLkTikqmfWhLuTiP8tPqcCGMZUe=iDOJVUZGy8pnRL0@mail.gmail.com>
Subject: Re: [PATCH 0/9] PCI: revert to allocating bottom-up, avoid E820 areas
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Adam Belay <abelay@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 9:38 AM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>
> So I think the best band-aid for now is to revert to bottom-up allocation
> and do a better job of avoiding E820 reserved areas.  Obviously, it's not
> complete because we could still trip over ACPI devices (as in 23802), but
> that's a problem we've always had and it's not as likely if we go bottom-up.

Ok, ack for this series. Have we got testers for it? In particular,
have the people who have seen regressions been notified of this new
series?

That said, let's just try to merge it quickly so that we get maximal
coverage before the holiday season starts. Jesse, it makes sense
through your tree, but if you'd rather me take it directly, I can do
that.

                        Linus
