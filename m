Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862Ab0E1R2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 13:28:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:32976 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab0E1R2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 13:28:21 -0400
Subject: Re: [linux-pm] [PATCH 8/8] intel_idle: create a native cpuidle
 driver for select intel processors
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Igor Stoppa <igor.stoppa@nokia.com>, Brown <len.brown@intel.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Len@smtp1.linux-foundation.org" <Len@smtp1.linux-foundation.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
In-Reply-To: <20100527201439.6d0fd169@infradead.org>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
	 <e099975ca65a7f6ac7f8bc3fee84d3e03893aa31.1274926772.git.len.brown@intel.com>
	 <198450ec1600d9a7f55270dd4d44d6b55bc5b184.1274926772.git.len.brown@intel.com>
	 <87ljb5l9d5.fsf@deeprootsystems.com>
	 <20100527072207.2e783b1e@infradead.org> <4BFE86D4.60602@nokia.com>
	 <20100527201439.6d0fd169@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Deep Root Systems, LLC
Date: Fri, 28 May 2010 10:27:32 -0700
Message-ID: <1275067652.4507.192.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 20:14 -0700, Arjan van de Ven wrote:
> On Thu, 27 May 2010 17:51:00 +0300
> Igor Stoppa <igor.stoppa@nokia.com> wrote:
> 
> > Hi,
> > 
> > 
> > ext Arjan van de Ven wrote:
> > 
> > > it's really inconvenient to have such drivers hidden in the
> > > architecture code; it's much more convenient for cpuidle developers
> > > if they're all in one place.
> > >   
> > 
> > why?
> 
> because you have all the users of your API in one place.
> 

That's a rather x86-centric definition of "all".

Are you suggesting we move all the embedded SoC specific CPUidle drivers
to drivers/idle as well?

Kevin


