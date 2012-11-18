Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab2KRWmx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 17:42:53 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37366 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab2KRWmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 17:42:51 -0500
Date: Sun, 18 Nov 2012 14:42:48 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Denys Fedoryshchenko <denys@visp.net.lb>
cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Michael Chan <mchan@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Latest 3.6.6 are not compiling due tg3 network driver,
 hwmon_device_unregister
In-Reply-To: <50A464E4.1080105@broadcom.com>
Message-ID: <alpine.DEB.2.00.1211181441470.5080@chino.kir.corp.google.com>
References: <8b566c4a9ee622737212dc17291ee238@visp.net.lb> <50A4606D.4020402@broadcom.com> <alpine.DEB.2.00.1211141929510.14414@chino.kir.corp.google.com> <50A464E4.1080105@broadcom.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Nithin Nayak Sujir wrote:

> On 11/14/2012 07:30 PM, David Rientjes wrote:
> > On Wed, 14 Nov 2012, Nithin Nayak Sujir wrote:
> > 
> > > This was fixed by
> > > 
> > > commit de0a41484c47d783dd4d442914815076aa2caac2
> > > Author: Paul Gortmaker <paul.gortmaker@windriver.com>
> > > Date:   Mon Oct 1 11:43:49 2012 -0400
> > > 
> > >      tg3: unconditionally select HWMON support when tg3 is enabled.
> > > 
> > Would you mind submitting this for stable by following the procedure
> > described in Documentation/stable_kernel_rules.txt?
> > 
> 
> Will do. Thank you for bringing this to our attention.
> 

Thanks for submitting the patch to stable, Greg has queued it for the 
kernels he maintains.  Denys, expect to see this fix in 3.6.8.
