Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320Ab0KOUFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:05:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40182 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552Ab0KOUFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:05:30 -0500
Message-ID: <4CE1920F.5000509@zytor.com>
Date: Mon, 15 Nov 2010 12:03:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@novell.com>, Avi Kivity <avi@redhat.com>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 00/20] x86: ticket lock rewrite and paravirtualization
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com> <4CDDBBD3.5050903@zytor.com> <4CDDBCE4.80906@goop.org> <4CDDBDB5.8000800@zytor.com> <4CE1915F.60507@goop.org>
In-Reply-To: <4CE1915F.60507@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 12:00 PM, Jeremy Fitzhardinge wrote:
> 
> Another approach I discussed with PeterZ and Mathieu is to steal the LSB
> of the ticket counters (halving the max CPU count) to use as a "there is
> someone in slowpath waiting on this lock".  But I haven't spent the time
> to work out an algorithm to maintain that flag (or flags, since there
> are bits available) in a correct and efficient way.
> 

Definitely worth pondering.

	-hpa

