Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab1KLArK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 19:47:10 -0500
Received: from na3sys010aog111.obsmtp.com ([74.125.245.90]:54847 "HELO
	na3sys010aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754535Ab1KLArI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 19:47:08 -0500
MIME-Version: 1.0
In-Reply-To: <1321058267.2006.21.camel@shinybook.infradead.org>
References: <20111111224849.9756.13368.stgit@bling.home> <1321058267.2006.21.camel@shinybook.infradead.org>
From: Roland Dreier <roland@purestorage.com>
Date: Fri, 11 Nov 2011 16:46:45 -0800
Message-ID: <CAL1RGDXZjKhA++3eFVPbazixaM7Q_JfBJyLKE0xjBs+sK55idg@mail.gmail.com>
Subject: Re: [PATCH] intel-iommu: Default to non-coherent for domains
 unattached to iommus
To: David Woodhouse <dwmw2@infradead.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, chrisw@sous-sol.org, ddutile@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 4:37 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> This brain-damage only affects the first chipsets
> from before we worked out that cache incoherency was a *really* f*cking
> stupid idea, doesn't it?

As we talked about at KS, I have some Westmere EP (ie latest
and greatest server platform) systems where the BIOS exposes
an option that allows choosing VT-d coherency on or off, and
defaults it to "off".

What is the "official" Intel line on coherency with Westmere and
Tylersburg -- because as I also mentioned, I was seeing some
problems with VT-d and the default "coherency off" setting that
looked like the IOMMU HW is getting stale PTEs (ie a missing
or not working cache flush).

 - R.
