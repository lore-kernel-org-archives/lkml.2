Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab2GaVwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 17:52:51 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:56902 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753640Ab2GaVwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 17:52:49 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.231;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail04v.am.sony.com;RD:mail.sonyusa.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI936eI1432Izz1202hzzz2fh2a8h668h839hf0ah107ah10d2h)
Message-ID: <50185399.4060104@am.sony.com>
Date: Tue, 31 Jul 2012 14:52:25 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "chris.pringle@miranda.com" <chris.pringle@miranda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH RT 05/12] slab: Prevent local lock deadlock
References: <20120718223910.898476857@goodmis.org>			 <20120718223957.856443728@goodmis.org> <5011DD9B.1030901@am.sony.com>		 <1343697755.27983.17.camel@gandalf.stny.rr.com>		 <50174158.4000408@am.sony.com>	 <1343701935.27983.18.camel@gandalf.stny.rr.com>	 <50182B44.8090100@am.sony.com> <1343761902.27983.67.camel@gandalf.stny.rr.com>
In-Reply-To: <1343761902.27983.67.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/12 12:11, Steven Rostedt wrote:
> On Tue, 2012-07-31 at 12:00 -0700, Frank Rowand wrote:
> 
>>> Yeah, my root fs is on the sdcard. Did you get this bug every time or
>>> was it sporadic?
>>
>> I get it every boot.
> 
> Can you try it with an SD card? I can set it up for nfs as well, but
> that would take a bit of time.

That would turn into a project for me, not likely to get to it soon.
But I'll put it on my "try to get to" list.

-Frank

