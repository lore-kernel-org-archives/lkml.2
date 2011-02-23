Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab1BWUhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:37:23 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53886 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563Ab1BWUhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:37:20 -0500
Date: Wed, 23 Feb 2011 13:37:15 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Daniel Drake <dsd@laptop.org>
Cc: Andres Salomon <dilinger@queued.net>,
        David Woodhouse <dwmw2@infradead.org>, cbou@mail.ru,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, dmitry.torokhov@gmail.com,
        devicetree-discuss@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [PATCH] of/pdt: allow DT device matching by fixing 'name'
 brokenness
Message-ID: <20110223203715.GU14597@angua.secretlab.ca>
References: <20110216222820.487AE9D401C@zog.reactivated.net>
 <1297896277.3011.5.camel@macbook.infradead.org>
 <AANLkTikAF2X1A5jfoNfCPRhZkZ7qPdZ57c8B5b9z4+qr@mail.gmail.com>
 <20110218190659.7f955e4c@queued.net>
 <20110223194352.GR14597@angua.secretlab.ca>
 <20110223115414.547b8c17@queued.net>
 <AANLkTi=D1eWGsN4JVWEGeHp3AXfpbOOKr9Fq7juGAXtT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=D1eWGsN4JVWEGeHp3AXfpbOOKr9Fq7juGAXtT@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 08:06:47PM +0000, Daniel Drake wrote:
> On 23 February 2011 19:54, Andres Salomon <dilinger@queued.net> wrote:
> >> Wait; why are you binding to a device based on name?  Binding by name
> >> and/or device_type is strongly discouraged for new code.  Use
> >> compatible instead.
> >>
> >
> > Daniel posted a separate patch showing his code, would you mind
> > commenting on that?  I noticed he didn't cc you though, here's the
> > patch:
> >
> > https://patchwork.kernel.org/patch/574901/
> 
> It does bind to the name.
> We don't currently have a compatible property for the battery device.
> We could fix that with a firmware upgrade, but it would break
> compatibility with all existing installs. I guess this is still the
> recommended approach...

Hi Daniel,

As mentioned in my reply to your patch, the solution to this is fix up
the missing compatible property in the board support code before it
pollutes the global matching namespace.

g.

