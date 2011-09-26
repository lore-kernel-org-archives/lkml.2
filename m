Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab1IZUma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 16:42:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19633 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab1IZUm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 16:42:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=ZN98ViQ7IA5kAoLMF9jy0OVB5gIAoeaHqIlBGrIHbfHrxcjoIgmKEeBALjYq3mIOi
	JJ49MGZZ1Q/uKQtzrzquw==
MIME-Version: 1.0
In-Reply-To: <20110926142606.GD15002@8bytes.org>
References: <1316706551-16138-1-git-send-email-joerg.roedel@amd.com> <20110926142606.GD15002@8bytes.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 26 Sep 2011 14:42:01 -0600
Message-ID: <CAErSpo6pcwZApQAmtUfJLwPu1JovTTQ8vsXzQTb+3hvocd1CBQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] Support for PRI and PASID capability
To: Joerg Roedel <joro@8bytes.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 8:26 AM, Joerg Roedel <joro@8bytes.org> wrote:
>
> Hi Jesse,
>
> On Thu, Sep 22, 2011 at 05:49:07PM +0200, Joerg Roedel wrote:
> > here is a patch-set that enables support for the PRI and PASID
> > capabilities in the Linux PCI core. These capabilities of a PCIe device
> > are tightly coupled with ATS, but not with IOV. So these patches start
> > by moving the ATS code into its own file: ats.c.
> >
> > Support for the other two capabilities is based on that change. Please
> > review the patches and let me know of any objections you might have.
>
> Have you had a chance to look at these patches? Please let me know any
> questions or objections you might have.

Jesse's on vacation, but I'll take a look and give you my opinion
(which won't necessarily coincide with Jesse's, but I guess it's a
start :)).

Bjorn
