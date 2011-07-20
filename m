Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab1GTA3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 20:29:47 -0400
Received: from tundra.namei.org ([65.99.196.166]:41536 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab1GTA3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 20:29:46 -0400
Date: Wed, 20 Jul 2011 10:29:38 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, rdunlap@xenotime.net,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: Re: [PATCH] tpm: Fix compilation warning when CONFIG_PNP is not
 defined
In-Reply-To: <4E242049.1030604@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1107201029230.23408@tundra.namei.org>
References: <1310903758.15064.9.camel@d941e-10> <20110718091624.bd262188190c5d7a05416b99@canb.auug.org.au> <4E242049.1030604@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jul 2011, Stefan Berger wrote:

> > > -#ifdef CONFIG_ACPI
> > > +#ifdef CONFIG_PNPN
> >                   ^^^^
> > Is this a typo?
> > 
> Argh, yes.

Do you have an updated version?


-- 
James Morris
<jmorris@namei.org>
