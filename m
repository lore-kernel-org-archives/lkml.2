Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761151Ab0J0PAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:00:04 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:56151 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab0J0PAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:00:01 -0400
Date: Wed, 27 Oct 2010 10:59:47 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 24/30] staging/vme_user: remove unnecessary call to
 vme_slave_set
Message-ID: <20101027145947.GQ10869@flamenco.cs.columbia.edu>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
 <1288055476-19438-25-git-send-email-cota@braap.org>
 <4CC81A17.7090805@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC81A17.7090805@ge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 13:24:55 +0100, Martyn Welch wrote:
> On 26/10/10 02:11, Emilio G. Cota wrote:
> > From: Emilio G. Cota <cota@braap.org>
> > 
> > The resource is about to be freed and therefore it is pointless to
> > set any of its parameters.
> 
> Nope - this is disabling the window, which given that you are about to
> unalloc the memory that it is using this is quite important.

Aah I didn't realise that 

> > -		vme_slave_set(image[i].resource, 0, 0, 0, 0, VME_A32, 0);

disables the window. I thought vme_slave_free would disable it as well.
Forget this one, then.

Thanks

		Emilio

