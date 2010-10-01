Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab0JAQq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 12:46:59 -0400
Received: from claw.goop.org ([74.207.240.146]:38363 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab0JAQq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 12:46:58 -0400
Message-ID: <4CA61080.6070709@goop.org>
Date: Fri, 01 Oct 2010 09:46:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Kyle McMartin <kyle@redhat.com>, stable@kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Dingwall <james.dingwall@amdocs.com>
Subject: Re: [stable] PROBLEM: [BISECTED] 2.6.35.5 xen domU panics just	after
 the boot
References: <3B7AEC3C7FCC864282DFAC9A56A7BA363D81475787@UKLNDMAIL1.corp.amdocs.com> <20100927024044.GQ13116@bombadil.infradead.org> <20100927061336.GA22721@kroah.com> <4CA0DDAB.9090507@goop.org> <20100928182910.GA32464@kroah.com> <4CA35FB7.10600@goop.org> <20100930000644.GA26380@kroah.com>
In-Reply-To: <20100930000644.GA26380@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 09/29/2010 05:06 PM, Greg KH wrote:
> On Wed, Sep 29, 2010 at 08:48:07AM -0700, Jeremy Fitzhardinge wrote:
>>
>> I should have pointed out it is the same in the stable-2.6.32 tree as well.
> Yes, sorry, I know, I only had the chance to get the .35 release out
> yesterday, I'll do the .32 one now.
>

Ping?  Looks like the fix hasn't hit stable-2.6.32/master yet.

Thanks,
    J
