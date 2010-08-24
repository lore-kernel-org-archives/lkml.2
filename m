Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0HXHUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:20:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:43796 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab0HXHU3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:20:29 -0400
Subject: Re: [RFC] mlock/stack guard interaction fixup
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ian Jackson <ijackson@chiark.greenend.org.uk>,
        Greg KH <gregkh@suse.de>, Ian Campbell <ijc@hellion.org.uk>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
In-Reply-To: <1282633694.2605.2254.camel@laptop>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>
	 <1282391770.29609.1223.camel@localhost.localdomain>
	 <AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>
	 <1282460275.11348.865.camel@localhost.localdomain>
	 <1282462386.11348.871.camel@localhost.localdomain>
	 <1282470917.11348.891.camel@localhost.localdomain>
	 <20100822172548.GB8957@suse.de>
	 <AANLkTi=wWcAg8MdWy4O-0au3m6mH+9xWDOKVCJ_x5G_v@mail.gmail.com>
	 <19570.38608.79434.179797@chiark.greenend.org.uk>
	 <1282580751.2605.1997.camel@laptop>
	 <19570.44367.719276.128881@chiark.greenend.org.uk>
	 <AANLkTi=+O8wKZV6XT5wGJbfZdgC9kxTxvtEZMD+M+pZn@mail.gmail.com>
	 <4C72C2E9.3070408@goop.org> <1282590457.2605.2200.camel@laptop>
	 <4C72CAA7.5070202@goop.org> <1282591592.2605.2221.camel@laptop>
	 <4C72D1E1.1040709@goop.org>  <1282633694.2605.2254.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 24 Aug 2010 09:20:16 +0200
Message-ID: <1282634416.2605.2272.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 09:08 +0200, Peter Zijlstra wrote:

> > Won't dirty anonymous pages also get written to swap?

Also, usually when we talk about dirty pages we mean file pages.


