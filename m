Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab1JHCfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 22:35:10 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41877 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab1JHCfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 22:35:06 -0400
Date: Sat, 8 Oct 2011 10:34:55 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 54/57] Documentation: irq: Change documents related to
 IRQF_DISABLED
Message-ID: <20111008023455.GA5394@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
 <1316597339-29861-55-git-send-email-yong.zhang0@gmail.com>
 <CAErSpo7EUw_4sKXXd2pYkTuqvBFOHgZ1zwrv68K3OU57-QE2Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAErSpo7EUw_4sKXXd2pYkTuqvBFOHgZ1zwrv68K3OU57-QE2Dw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 04:33:08PM -0600, Bjorn Helgaas wrote:
> On Wed, Sep 21, 2011 at 3:28 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> > IRQF_DISABLED is a NOOP now, place where suggest to use this
> > flag also doesn't make sense any more.
> >
> > Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> 
> I assume this will be applied via some non-PCI tree (let me know if
> otherwise).  The MSI-HOWTO.txt change looks fine to me.

(Sorry for my late response because of long vacation)

So if you could pick it up, just go ahead, otherwise tglx will
take it :)

> 
> > --- a/Documentation/scsi/ncr53c8xx.txt
> > +++ b/Documentation/scsi/ncr53c8xx.txt
> > @@ -786,7 +786,9 @@ port address 0x1400.
> > ? ? ? ? irqm:1 ? ? same as initial settings (assumed BIOS settings)
> > ? ? ? ? irqm:2 ? ? always totem pole
> > ? ? ? ? irqm:0x10 ?driver will not use IRQF_SHARED flag when requesting irq
> > - ? ? ? ?irqm:0x20 ?driver will not use IRQF_DISABLED flag when requesting irq
> > + ? ? ? ?irqm:0x20 ?driver will not use IRQF_DISABLED (does not make sense
> > + ? ? ? ? ? ? ? ? ?any more since genirq will keep irq disabled and the flag
> > + ? ? ? ? ? ? ? ? ?is dead from linux-2.6.35) flag when requesting irq
> >
> > ? ? (Bits 0x10 and 0x20 can be combined with hardware irq mode option)
> 
> The new text doesn't make sense to me.  I think it should say something like:
> 
>     irqm:0x20  driver will not use IRQF_DISABLED flag when requesting
> irq (only useful for linux-2.6.34 and earlier)

Hmmm, it seems more simple :)
Will update it. Thanks for your idea.

Yong

