Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab0HWTX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 15:23:26 -0400
Received: from claw.goop.org ([74.207.240.146]:53806 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469Ab0HWTXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 15:23:23 -0400
Message-ID: <4C72CAA7.5070202@goop.org>
Date: Mon, 23 Aug 2010 12:23:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ian Jackson <ijackson@chiark.greenend.org.uk>,
        Greg KH <gregkh@suse.de>, Ian Campbell <ijc@hellion.org.uk>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [RFC] mlock/stack guard interaction fixup
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>	 <1282391770.29609.1223.camel@localhost.localdomain>	 <AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>	 <1282460275.11348.865.camel@localhost.localdomain>	 <1282462386.11348.871.camel@localhost.localdomain>	 <1282470917.11348.891.camel@localhost.localdomain>	 <20100822172548.GB8957@suse.de>	 <AANLkTi=wWcAg8MdWy4O-0au3m6mH+9xWDOKVCJ_x5G_v@mail.gmail.com>	 <19570.38608.79434.179797@chiark.greenend.org.uk>	 <1282580751.2605.1997.camel@laptop>	 <19570.44367.719276.128881@chiark.greenend.org.uk>	 <AANLkTi=+O8wKZV6XT5wGJbfZdgC9kxTxvtEZMD+M+pZn@mail.gmail.com>	 <4C72C2E9.3070408@goop.org> <1282590457.2605.2200.camel@laptop>
In-Reply-To: <1282590457.2605.2200.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 08/23/2010 12:07 PM, Peter Zijlstra wrote:
> mlock() simply avoids major faults, nothing more.
>
> I think both page migration and page-out for shared pages where some
> maps are !mlocked can cause unmaps and thus minor faults.
>
> mlock and dirty do not interact, they will still be cleaned/written out
> as normal.

So mlock is useless for preventing secret stuff from being written to disk.

    J
