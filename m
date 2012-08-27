Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab2H0SCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 14:02:21 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:45228 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab2H0SCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 14:02:18 -0400
Date: Mon, 27 Aug 2012 13:02:10 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: Peter.Huewe@infineon.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, adlai@linux.vnet.ibm.com,
        xiaoyan.zhang@intel.com, jj@chaosbits.net
Subject: Re: [GIT PULL] tpmdd: TPM drivers, tpm-rng and fixes
Message-ID: <20120827180210.GA14509@linux.vnet.ibm.com>
References: <20120822215216.GC13519@linux.vnet.ibm.com>
 <alpine.LRH.2.02.1208240632120.25506@tundra.namei.org>
 <74A44E99E3274B4CB570415926B37D440E13FD@MUCSE501.eu.infineon.com>
 <20120824150533.GA2190@linux.vnet.ibm.com>
 <alpine.LRH.2.02.1208250759150.1650@tundra.namei.org>
 <74A44E99E3274B4CB570415926B37D440E4B5A@MUCSE501.eu.infineon.com>
 <20120827161747.GA2436@linux.vnet.ibm.com>
 <alpine.LRH.2.02.1208280321220.17312@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1208280321220.17312@tundra.namei.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082718-7408-0000-0000-000007F31FB5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 03:21:51AM +1000, James Morris wrote:
> On Mon, 27 Aug 2012, Kent Yoder wrote:
> 
> > On Mon, Aug 27, 2012 at 07:23:40AM +0000, Peter.Huewe@infineon.com wrote:
> > > >> > Build using make -> no error.
> > > >>   I can't reproduce this either, James, can you send out your .config?
> > > 
> > > > See attached.
> > > 
> > > Hi James,
> > > 
> > > even with you config, I can't reproduce it here with 3.6-rc3 + mypatch.
> > 
> >   Same here, against linux-security plus the pullreq patches...
> 
> I may have missed something, but what do you mean by pullreq patches?

  Just the stuff I asked you to pull here.

Kent

> 
> 
> -- 
> James Morris
> <jmorris@namei.org>
> 

