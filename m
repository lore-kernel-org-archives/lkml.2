Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab1AZAZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 19:25:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36314 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab1AZAZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 19:25:22 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=VWN6VrN-768A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=zTlCZqnQumJpY5A9xbwA:9 a=n1MBiUOBuzvPrXm3qD-FJbScdT4A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [patch 1/3] introduce __u64_aligned and U64_ALIGN() for
 structure alignment in custom sections (v3)
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@elte.hu, richm@oldelvet.org.uk,
        ben@decadent.org.uk, sparclinux@vger.kernel.org,
        stable <stable@kernel.org>
In-Reply-To: <20110125233451.GA29539@Krystal>
References: <20110121203630.725922272@efficios.com>
	 <20110121203642.725191236@efficios.com>
	 <20110121.160503.233879710.davem@davemloft.net>
	 <20110122171134.GA31308@Krystal>
	 <1295718225.12215.4822.camel@gandalf.stny.rr.com>
	 <20110125233451.GA29539@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 25 Jan 2011 19:25:18 -0500
Message-ID: <1296001518.10144.63.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 18:34 -0500, Mathieu Desnoyers wrote:

> Any progress on the merge process for this bugfix patch series ? The issue
> seemed rather pressing last week, given that it breaks sparc64.

I was hoping to resolve the bug, but its not that reproducible and
screws up the bisect.

I'll disable the feature that is broken (for now) and continue with your
patches. Hopefully everything will go smoothly, and I can push these out
tonight or tomorrow morning.

-- Steve


