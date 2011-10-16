Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab1JPBxD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 21:53:03 -0400
Received: from claw.goop.org ([74.207.240.146]:54840 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab1JPBxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 21:53:01 -0400
Message-ID: <4E9A38FA.7030504@goop.org>
Date: Sat, 15 Oct 2011 18:52:58 -0700
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
References: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com>   <c133180533d7e520bb1e818e987117811a666fbc.1318464413.git.jeremy.fitzhardinge@citrix.com>  <1318502628.24856.10.camel@twins> <4E98AEDD.4010503@goop.org> <1318668158.6594.0.camel@twins>
In-Reply-To: <1318668158.6594.0.camel@twins>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2011 01:42 AM, Peter Zijlstra wrote:
> On Fri, 2011-10-14 at 14:51 -0700, Jeremy Fitzhardinge wrote:
>> How about this?  Proper comment and much earlier init.
> Looks good to me, thanks!

Should I take that as an ACK on the series?

    J
