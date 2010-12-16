Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab0LPWD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 17:03:29 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:46815 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753948Ab0LPWD0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 17:03:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ZzYG/RgR7dAG+8T9XcrAQ9gN8vnuK8okIv96edhtKMqpX7LmyxTvj7+xas/xZq7OQL+j65JEbk/McOUfqT8+RWIf2i5fOB6igAeAHY2J+l0f5Xn1uqm+zU+uEQJknjig;
Date: Thu, 16 Dec 2010 14:03:21 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Adam Belay <abelay@mit.edu>
Subject: Re: [PATCH 0/9] PCI: revert to allocating bottom-up, avoid E820
 areas
Message-ID: <20101216140321.1a75ccef@jbarnes-desktop>
In-Reply-To: <AANLkTikqmfWhLuTiP8tPqcCGMZUe=iDOJVUZGy8pnRL0@mail.gmail.com>
References: <20101216173614.8185.19462.stgit@bob.kio>
	<AANLkTikqmfWhLuTiP8tPqcCGMZUe=iDOJVUZGy8pnRL0@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Dec 2010 13:59:33 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Dec 16, 2010 at 9:38 AM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> >
> > So I think the best band-aid for now is to revert to bottom-up allocation
> > and do a better job of avoiding E820 reserved areas.  Obviously, it's not
> > complete because we could still trip over ACPI devices (as in 23802), but
> > that's a problem we've always had and it's not as likely if we go bottom-up.
> 
> Ok, ack for this series. Have we got testers for it? In particular,
> have the people who have seen regressions been notified of this new
> series?
> 
> That said, let's just try to merge it quickly so that we get maximal
> coverage before the holiday season starts. Jesse, it makes sense
> through your tree, but if you'd rather me take it directly, I can do
> that.

I'll pull it into my tree and send you a pull req tomorrow if that's
ok.  I have a couple of fixes besides this, but I have to drop Bjorn's
earlier series...

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
