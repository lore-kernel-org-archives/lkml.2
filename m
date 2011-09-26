Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab1IZU7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 16:59:08 -0400
Received: from 8bytes.org ([88.198.83.132]:54858 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab1IZU7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 16:59:06 -0400
Date: Mon, 26 Sep 2011 22:59:04 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Support for PRI and PASID capability
Message-ID: <20110926205904.GF15002@8bytes.org>
References: <1316706551-16138-1-git-send-email-joerg.roedel@amd.com> <20110926142606.GD15002@8bytes.org> <CAErSpo6pcwZApQAmtUfJLwPu1JovTTQ8vsXzQTb+3hvocd1CBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6pcwZApQAmtUfJLwPu1JovTTQ8vsXzQTb+3hvocd1CBQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 02:42:01PM -0600, Bjorn Helgaas wrote:
> On Mon, Sep 26, 2011 at 8:26 AM, Joerg Roedel <joro@8bytes.org> wrote:
> >
> > Hi Jesse,
> >
> > On Thu, Sep 22, 2011 at 05:49:07PM +0200, Joerg Roedel wrote:
> > > here is a patch-set that enables support for the PRI and PASID
> > > capabilities in the Linux PCI core. These capabilities of a PCIe device
> > > are tightly coupled with ATS, but not with IOV. So these patches start
> > > by moving the ATS code into its own file: ats.c.
> > >
> > > Support for the other two capabilities is based on that change. Please
> > > review the patches and let me know of any objections you might have.
> >
> > Have you had a chance to look at these patches? Please let me know any
> > questions or objections you might have.
> 
> Jesse's on vacation, but I'll take a look and give you my opinion
> (which won't necessarily coincide with Jesse's, but I guess it's a
> start :)).

Great. Thanks a lot :)

	Joerg

