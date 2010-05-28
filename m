Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab0E1R2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 13:28:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:32976 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab0E1R2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 13:28:45 -0400
Subject: Re: [PATCH 8/8] intel_idle: create a native cpuidle driver for
 select intel processors
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Len Brown <lenb@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>, x86@kernel.org,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1005272009490.24823@localhost.localdomain>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
	 <e099975ca65a7f6ac7f8bc3fee84d3e03893aa31.1274926772.git.len.brown@intel.com>
	 <198450ec1600d9a7f55270dd4d44d6b55bc5b184.1274926772.git.len.brown@intel.com>
	 <87ljb5l9d5.fsf@deeprootsystems.com>
	 <20100527072207.2e783b1e@infradead.org>
	 <87ocg1jts7.fsf@deeprootsystems.com>
	 <alpine.LFD.2.00.1005272009490.24823@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: Deep Root Systems, LLC
Date: Fri, 28 May 2010 10:28:30 -0700
Message-ID: <1275067710.4507.194.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 20:22 -0400, Len Brown wrote:
> > >> >  drivers/idle/intel_idle.c       |  446
> 
> > >> Any reason this arch-specific driver needs to be in drivers/idle
> > >> instead of under a platform specific dir like arch/x86?
> 
> > To me that would be much less convenient as I expect to maintain my
> > platform-specific CPUidle driver along with the rest of my
> > platform-specific code.
> 
> I guess the reason is conveneince of the maintainer (me).

OK, fair enough.

At least that makes more sense to me than "keeping all users in one
place."

Kevin


