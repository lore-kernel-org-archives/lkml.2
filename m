Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab2BUL6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 06:58:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:43292 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342Ab2BUL6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 06:58:20 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of matt.fleming@intel.com designates 10.68.190.8 as permitted sender) smtp.mail=matt.fleming@intel.com
Subject: Re: build failure in Linus' tree with gcc 4.4.3
From: Matt Fleming <matt.fleming@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120221225118.a2e510b249cefd66be08749e@canb.auug.org.au>
References: <20120220133936.936bff0d5817ac609a5211e0@canb.auug.org.au>
	 <20120220142208.ab97f13b9ade345402d054fb@canb.auug.org.au>
	 <1329731019.3639.20.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1329818517.3639.29.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20120221213818.34410cc74de633cda0169819@canb.auug.org.au>
	 <1329823933.3639.6.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20120221225118.a2e510b249cefd66be08749e@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Tue, 21 Feb 2012 11:58:11 +0000
Message-ID: <1329825491.3639.8.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 22:51 +1100, Stephen Rothwell wrote:
> Hi Matt,
> 
> On Tue, 21 Feb 2012 11:32:13 +0000 Matt Fleming <matt.fleming@intel.com> wrote:
> >
> > +static inline u32 read32_le(u8 *src)
> > +{
> > +	u32 data;
> > +
> > +	data = *src++;
> > +	data |= *src++ >> 8;
> > +	data |= *src++ >> 16;
> > +	data |= *src++ >> 24;
> 
> Shouldn't these be "<<" ?

Oops. Yes.


