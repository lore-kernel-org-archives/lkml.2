Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab1EHSto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:49:44 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44269 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab1EHStl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:49:41 -0400
Date: Sun, 8 May 2011 20:49:11 +0200
From: Borislav Petkov <bp@amd64.org>
To: Greg KH <greg@kroah.com>
Cc: EDAC devel <linux-edac@vger.kernel.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH 3/4] EDAC, MCE, AMD: Add hw_inject and cpu sysfs attrs
Message-ID: <20110508184911.GA511@aftab>
References: <1304614176-7063-1-git-send-email-bp@amd64.org>
 <1304614176-7063-4-git-send-email-bp@amd64.org>
 <20110508164054.GA4199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110508164054.GA4199@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 08, 2011 at 12:40:54PM -0400, Greg KH wrote:
> On Thu, May 05, 2011 at 06:49:35PM +0200, Borislav Petkov wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > Add sysfs handlers for the 'hw_inject' and 'cpu' attrs.
> 
> You forgot to add the proper Documentation/ABI/ files for these new
> sysfs files.  Please do that.

Yeah, so those sprang up as a testing module and the final goal is to
have all injection done through perf events but it could also be prudent
to keep those as a fallback alternative.

I'm thinking something like
Documentation/ABI/testing/sysfs-devices-system-edac but looking
at Documentation/ABI/README and reading the "testing/" category
description, I don't think it applies to those interfaces just yet for
the simple reason that they're still changing and I wouldn't want to
cast them in stone now.

Can we add them to a "unstable" category instead or maybe delay making
the ABI description for now?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
