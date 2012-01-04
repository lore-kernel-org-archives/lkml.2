Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab2ADVZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 16:25:50 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:35617 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952Ab2ADVZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 16:25:49 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA4=j_pXQ0L9NBoaGGGhEWFhga_LxVG-oi11vSrm4UG3Sg@mail.gmail.com>
References: <20120103185304.GA25184@hmsreliant.think-freely.org>
	<20120104091952.7cc5316d@jbarnes-desktop>
	<20120104195134.GB24324@hmsreliant.think-freely.org>
	<20120104.145619.1728971973635198635.davem@davemloft.net>
	<20120104120248.4f4747bf@jbarnes-desktop>
	<CA+5PVA4=j_pXQ0L9NBoaGGGhEWFhga_LxVG-oi11vSrm4UG3Sg@mail.gmail.com>
Date: Wed, 4 Jan 2012 16:25:47 -0500
Message-ID: <CA+5PVA4-Xofs3AKq3L2UjtmVLa4HpjMwv0_rMdXO5ku8uFvfkg@mail.gmail.com>
Subject: Re: [PATCH] msi: fix imbalanced refcount of msi irq sysfs objects
From: Josh Boyer <jwboyer@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Miller <davem@davemloft.net>, nhorman@tuxdriver.com,
        linux-kernel@vger.kernel.org, bhelgaas@google.com, gregkh@suse.de,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 4, 2012 at 4:18 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>>> The bug only exists in the PCI -next code I thought.
>>
>> Oh yeah, looks like it.  Lost track of my -next vs master branches
>> there...
>
> Er... Neil's commit log in the patch itself has an oops from 3.1.6 in
> it.  If the bug the patch fixes is only present in -next PCI code, how
> did it get hit on that release?
>
> Did we switch to talking about some other patch here and I'm just confused?

I'm just confused.  I forgot Neil backported that upstream code to the
F16 3.1.6 kernel.  Sorry for the noise.

josh
