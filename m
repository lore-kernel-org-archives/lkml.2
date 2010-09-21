Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab0IUWfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:35:00 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53203 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab0IUWe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:34:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=EWvVi+38HKjf1rKIJL5xoMTZ9/Pt/5Juc+FnJQIx/UYsE1STlraYbKb0iEL+pzNtfn
         7dfxKZFbjXd7mWeh0ruAIFxlraNzOw1pAD0t/e/qCozRc8G5c1UkSyLtBNZ10THcqkJM
         iA4w560YCWruDhOPRLnOj0dgEG+yIHHRiqbLw=
MIME-Version: 1.0
In-Reply-To: <20100921171746.381f2e89@udp111988uds.am.freescale.net>
References: <1285066638-7473-1-git-send-email-leoli@freescale.com>
 <877FD0B5-19A7-4A16-831E-369B80B104EA@kernel.crashing.org>
 <AANLkTimiwtoa6i10OTcgFnvbvcO9N4KWHyt4Poj-yj=T@mail.gmail.com>
 <20100921163456.7e2c9b32@udp111988uds.am.freescale.net> <AANLkTine--kry0c0n87WOqYyi3AQOb2KnmNRs-MeXcQt@mail.gmail.com>
 <20100921164944.164ed0af@udp111988uds.am.freescale.net> <2C3F2C02-35B6-46AF-82DA-44ACCBFB8362@digitaldans.com>
 <AANLkTinKbBBbC1gmPewhn1f3MW-1MbARtiQZNX4w7Mi+@mail.gmail.com> <20100921171746.381f2e89@udp111988uds.am.freescale.net>
From: Timur Tabi <timur.tabi@gmail.com>
Date: Tue, 21 Sep 2010 17:34:28 -0500
Message-ID: <AANLkTinbjb+uQdby999rs1eF1sqPHY2vXJ1mVrznFv=0@mail.gmail.com>
Subject: Re: [PATCH] fsldma: add support to 36-bit physical address
To: Scott Wood <scottwood@freescale.com>
Cc: Dan Malek <ppc6dev@digitaldans.com>, dan.j.williams@intel.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 5:17 PM, Scott Wood <scottwood@freescale.com> wrote:

> It needs to be the actual device that is performing the DMA -- the
> platform may need to do things such as IOMMU manipulation where
> knowing the device matters.

Ok, this all makes sense.  So it appears that the patch is valid, at
least in theory.  I would like to see some testing of it, but I
realize that may be too difficult.  There's no easy way to force an
allocation above 4GB.

-- 
Timur Tabi
Linux kernel developer at Freescale
