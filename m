Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab1JKUDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 16:03:37 -0400
Received: from kanga.kvack.org ([205.233.56.17]:57898 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab1JKUDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 16:03:36 -0400
Date: Tue, 11 Oct 2011 16:03:35 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Greg KH <greg@kroah.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jon Mason <mason@myri.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [01/38] PCI: Set PCI-E Max Payload Size on fabric
Message-ID: <20111011200335.GJ10838@kvack.org>
References: <20111011165903.GA30976@kroah.com> <20111011165708.466042477@pistachio.kroah.org> <20111011172019.GI10838@kvack.org> <CAErSpo6JFTm4y35Nz7aNUgM3ynX52fM1-AwX7OTOwm3cminv1Q@mail.gmail.com> <20111011192447.GC1112@kroah.com> <CAErSpo47Yw3Vygs5=OVmtUuLsB9FxJeYBm20UYem-Z3L7B0UhQ@mail.gmail.com> <20111011195611.GA2956@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111011195611.GA2956@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 01:56:11PM -0600, Greg KH wrote:
> > On Tue, Oct 11, 2011 at 1:24 PM, Greg KH <greg@kroah.com> wrote:
...
> > I'd like to know more about this regression.
> 
> It shows up as an oops that prevents the machine from booting.

If it's a regression, the patch should be limited to fixing the bug.  As 
it stands, this patch series introduces new functionality, and because it 
goes through a known broken state with the first patch, it may cause 
failures for people if they land in the middle during a bisect.  This 
doesn't seem like the right approach for -stable.

		-ben
