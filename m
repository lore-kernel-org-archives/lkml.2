Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab1BONuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 08:50:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36190 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1BONt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 08:49:59 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=4UV-9Kl2S54A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=6mN9YZ4VAAAA:8 a=Bctk8Vo7LU0E1bw7DVMA:9 a=q4dLda_fC3DuSFJ9-Xe5X71z5kEA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Will Newton <will.newton@gmail.com>, Matt Fleming <matt@console-pimps.org>,
        David Miller <davem@davemloft.net>, peterz@infradead.org,
        jbaron@redhat.com, mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        vapier@gentoo.org, cmetcalf@tilera.com, dhowells@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
In-Reply-To: <4D5A8021.2060001@zytor.com>
References: <1297707868.5226.189.camel@laptop>
	 <1297718964.23343.75.camel@gandalf.stny.rr.com>
	 <1297719576.23343.80.camel@gandalf.stny.rr.com>
	 <20110214.134600.179933733.davem@davemloft.net>
	 <20110214223755.436e7cf4@mfleming-mobl1.ger.corp.intel.com>
	 <4D59B891.8010300@zytor.com>
	 <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com>
	 <4D5A8021.2060001@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 15 Feb 2011 08:49:55 -0500
Message-ID: <1297777795.23343.107.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 05:31 -0800, H. Peter Anvin wrote:
> On 02/15/2011 03:01 AM, Will Newton wrote:

> b) Why should we let this particular insane CPU slow ALL OTHER CPUs down?

Yesterday I got around to reading Linus's interview here:

http://www.itwire.com/opinion-and-analysis/open-sauce/44975-linus-torvalds-looking-back-looking-forward?start=4

This seems appropriate:

"When it comes to "feature I had to include for reasons beyond my
control", it tends to be about crazy hardware doing stupid things that
we just have to work around. Most of the time that's limited to some
specific driver or other, and it's not something that has any relevance
in the "big picture", or that really affects core kernel design very
much. But sometimes it does, and then I really detest it."

-- Steve


