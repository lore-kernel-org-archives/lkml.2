Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab0JBVDX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 17:03:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50309 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab0JBVDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 17:03:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ihGLWe/CGNGYrw3WQINDbX0b9KvHS7mimOtTl5219a1fxSaS5WhhxRPvI6sV6z7S4j
         dCfBqrZPKaqjXz4YLXuZaHFI1UwedLj4UkACBhT0Rh0WDGZKf5AYwXD3uP4ij5EkMg2A
         OUKYJrANPJWOR/0n//TprydMsN6MHlnCnfdWk=
Date: Sat, 2 Oct 2010 23:03:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Corentin Chary <corentincj@iksaif.net>
Subject: Re: EeePC 900 reboots/hangs when using using perf -a -f -g
Message-ID: <20101002210314.GA5373@nowhere>
References: <20100912102854.GA7359@sucs.org> <1284289027.2251.95.camel@laptop> <20100912112105.GA28420@sucs.org> <20100912124653.GA5342@nowhere> <20100912162141.GB30698@sucs.org> <20100917030125.GA5389@nowhere> <20100921172711.GA31352@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100921172711.GA31352@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 06:27:11PM +0100, Sitsofe Wheeler wrote:
> On Fri, Sep 17, 2010 at 05:01:28AM +0200, Frederic Weisbecker wrote:
> > 
> > Ok, can you please send me your config?
> > 
> > I hope I can reproduce that.


I've been unable to reproduce with your config in latest tip:/perf/core,
I haven't tested in a eeepc though.

Did you check with 2.6.36-rc4 or with a tip branch?

Thanks.

