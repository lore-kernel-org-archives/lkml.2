Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab1JYTZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 15:25:56 -0400
Received: from claw.goop.org ([74.207.240.146]:46353 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab1JYTZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 15:25:54 -0400
Message-ID: <4EA6F830.7010304@goop.org>
Date: Tue, 25 Oct 2011 10:56:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC V4 10/10] jump-label: initialize jump-label subsystem
 much earlier
References: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com>    <c133180533d7e520bb1e818e987117811a666fbc.1318464413.git.jeremy.fitzhardinge@citrix.com>   <1318502628.24856.10.camel@twins> <4E98AEDD.4010503@goop.org>  <1318668158.6594.0.camel@twins> <4E9A38FA.7030504@goop.org> <1318935720.21167.15.camel@twins>
In-Reply-To: <1318935720.21167.15.camel@twins>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2011 04:02 AM, Peter Zijlstra wrote:
> On Sat, 2011-10-15 at 18:52 -0700, Jeremy Fitzhardinge wrote:
>> On 10/15/2011 01:42 AM, Peter Zijlstra wrote:
>>> On Fri, 2011-10-14 at 14:51 -0700, Jeremy Fitzhardinge wrote:
>>>> How about this?  Proper comment and much earlier init.
>>> Looks good to me, thanks!
>> Should I take that as an ACK on the series?
> Yes, I don't see any problems with it,
>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

How should this go upstream?   Should I submit it, or does someone else
want to do it?

Thanks,
    J

