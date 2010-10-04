Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab0JDWdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 18:33:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36626 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab0JDWdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 18:33:22 -0400
Message-ID: <4CAA55F9.90503@zytor.com>
Date: Mon, 04 Oct 2010 15:32:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Nick Lowe <nick.lowe@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        Daniel Drake <dsd@laptop.org>, Andres Salomon <dilinger@queued.net>,
        Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, Borislav Petkov <bp@alien8.de>
Subject: Re: Dynamic nop selection breaks boot on Geode LX
References: <AANLkTimF2tcksBkww50MhiO0YY=MCt4rcnfDR+tJhTUJ@mail.gmail.com>	<20101004154633.GA2900@redhat.com>	<4CAA4C7D.8040006@zytor.com>	<1286230518.6750.76.camel@gandalf.stny.rr.com>	<4CAA53A2.6070703@zytor.com> <AANLkTikCkwF+yd4kdad8Bcz-6YX+STiy1wgrFfJxsfRg@mail.gmail.com>
In-Reply-To: <AANLkTikCkwF+yd4kdad8Bcz-6YX+STiy1wgrFfJxsfRg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2010 03:25 PM, Nick Lowe wrote:
> > As far as I'm aware, the check is just broken in VMs that trace their
> > lineage to Connectix's VirtualPC that Microsoft acquired back in 2006.
> > Is this correct? On balance, is this really to be cared about?
If it was a huge win from using NOPL, then it would perhaps not be -- or
we'd go through more effort at detecting the broken cases.  However,
since it's not, it's easier to just avoid it.

	-hpa
