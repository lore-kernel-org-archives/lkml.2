Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab2H0RZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:25:08 -0400
Received: from tundra.namei.org ([65.99.196.166]:57017 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab2H0RZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:25:05 -0400
Date: Tue, 28 Aug 2012 03:21:51 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kent Yoder <key@linux.vnet.ibm.com>
cc: Peter.Huewe@infineon.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, adlai@linux.vnet.ibm.com,
        xiaoyan.zhang@intel.com, jj@chaosbits.net
Subject: Re: [GIT PULL] tpmdd: TPM drivers, tpm-rng and fixes
In-Reply-To: <20120827161747.GA2436@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.02.1208280321220.17312@tundra.namei.org>
References: <20120822215216.GC13519@linux.vnet.ibm.com> <alpine.LRH.2.02.1208240632120.25506@tundra.namei.org> <74A44E99E3274B4CB570415926B37D440E13FD@MUCSE501.eu.infineon.com> <20120824150533.GA2190@linux.vnet.ibm.com> <alpine.LRH.2.02.1208250759150.1650@tundra.namei.org>
 <74A44E99E3274B4CB570415926B37D440E4B5A@MUCSE501.eu.infineon.com> <20120827161747.GA2436@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2012, Kent Yoder wrote:

> On Mon, Aug 27, 2012 at 07:23:40AM +0000, Peter.Huewe@infineon.com wrote:
> > >> > Build using make -> no error.
> > >>   I can't reproduce this either, James, can you send out your .config?
> > 
> > > See attached.
> > 
> > Hi James,
> > 
> > even with you config, I can't reproduce it here with 3.6-rc3 + mypatch.
> 
>   Same here, against linux-security plus the pullreq patches...

I may have missed something, but what do you mean by pullreq patches?


-- 
James Morris
<jmorris@namei.org>
