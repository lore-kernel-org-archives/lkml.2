Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab2H0QR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 12:17:29 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46823 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162Ab2H0QR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 12:17:27 -0400
Date: Mon, 27 Aug 2012 11:17:48 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Peter.Huewe@infineon.com
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, adlai@linux.vnet.ibm.com,
        xiaoyan.zhang@intel.com, jj@chaosbits.net
Subject: Re: [GIT PULL] tpmdd: TPM drivers, tpm-rng and fixes
Message-ID: <20120827161747.GA2436@linux.vnet.ibm.com>
References: <20120822215216.GC13519@linux.vnet.ibm.com>
 <alpine.LRH.2.02.1208240632120.25506@tundra.namei.org>
 <74A44E99E3274B4CB570415926B37D440E13FD@MUCSE501.eu.infineon.com>
 <20120824150533.GA2190@linux.vnet.ibm.com>
 <alpine.LRH.2.02.1208250759150.1650@tundra.namei.org>
 <74A44E99E3274B4CB570415926B37D440E4B5A@MUCSE501.eu.infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74A44E99E3274B4CB570415926B37D440E4B5A@MUCSE501.eu.infineon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082716-7182-0000-0000-0000026787B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 07:23:40AM +0000, Peter.Huewe@infineon.com wrote:
> >> > Build using make -> no error.
> >>   I can't reproduce this either, James, can you send out your .config?
> 
> > See attached.
> 
> Hi James,
> 
> even with you config, I can't reproduce it here with 3.6-rc3 + mypatch.

  Same here, against linux-security plus the pullreq patches...

Kent

> 
> 
> Peter
> 

