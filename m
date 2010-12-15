Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab0LOTWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 14:22:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754944Ab0LOTWc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 14:22:32 -0500
MIME-Version: 1.0
In-Reply-To: <201012151118.30512.bjorn.helgaas@hp.com>
References: <20101208213606.13026.47657.stgit@bob.kio> <20101215062650.GB2728@helgaas.com>
 <AANLkTi=U+CTn=RDvYG0w6JK0Owv_TEc9YNtAtm9DeLKi@mail.gmail.com> <201012151118.30512.bjorn.helgaas@hp.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Dec 2010 11:21:42 -0800
Message-ID: <AANLkTik7_6Oc6jcjQVVBmJ13LRFMopEg6qEdB43zMMz5@mail.gmail.com>
Subject: Re: [PATCH 5/5] PNP: HP nx6325 fixup: reserve unreported resources
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 10:18 AM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>
> So here's my proposal for .37:
>  - Keep the current state of _CRS enabled by default (for 2008
>    and newer machines).
>  - Allocate bottom-up always
>  - Avoid E820 reservations

Sounds sane to me. And yes, the fact that the BIOS tends to allocate
things top-down probably does mean that the whole bottom-up approach
tends to be the safer model.

                          Linus
