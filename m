Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783Ab2CAA16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:27:58 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:51579 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753805Ab2CAA14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:27:56 -0500
Date: Wed, 29 Feb 2012 16:27:43 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 39/39] x86, PCI: kill busn in acpi pci_root_info
Message-ID: <20120229162743.49d78c21@jbarnes-x220>
In-Reply-To: <20120229235128.GA5484@kroah.com>
References: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
	<1330556858-11768-40-git-send-email-yinghai@kernel.org>
	<CAErSpo63hAtPMFdSEuVCcgw5ERMkiKx2Z8pREc2PdiCwmWpvkg@mail.gmail.com>
	<CAE9FiQUeRno4ZCy37XQ+cwrFYG-XoDq7q=XjKrOVy5E85bS-ig@mail.gmail.com>
	<20120229235128.GA5484@kroah.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 174.253.241.144 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012 15:51:28 -0800
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Wed, Feb 29, 2012 at 03:37:53PM -0800, Yinghai Lu wrote:
> > On Wed, Feb 29, 2012 at 3:32 PM, Bjorn Helgaas

> > > You just *added* this stuff in a prior patch that hasn't been
> > > merged yet.  Why can't you just fix that series rather than doing
> > > the add/remove churn?
> > 
> > as i said before, I'm not quite sure about the life cycle about
> > that object.

I thought Bjorn figured that out for you in the last thread?

> > 
> > still need to wait some months to verify that on system that does
> > support pci root bus hot plug etc.
> > 
> > or we can just this patch for now.
> 
> A statement like that would cause all of these patches to be instantly
> deleted from any queue that I had control over, and I strongly
> recommend that Jesse just ignore them all.
> 
> If you don't know this thing, then you have no right to change it,
> flat out.  Why do we trust these patches from you?  I sure don't.

Oh don't worry, this patch set isn't going upstream anytime soon.
Bjorn has raised several good points that Yinghai has yet to
address...  I trust Bjorn's judgment on these, so until he's happy I
likely won't be merging them.
