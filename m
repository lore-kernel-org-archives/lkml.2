Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab0HCSNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:13:04 -0400
Received: from claw.goop.org ([74.207.240.146]:34556 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756981Ab0HCSNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:13:01 -0400
Message-ID: <4C585C26.1050100@goop.org>
Date: Tue, 03 Aug 2010 11:12:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        NetDev <netdev@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "Xu, Dongxiao" <dongxiao.xu@intel.com>
Subject: Re: [GIT PULL] xen-netfront driver updates for 2.6.36
References: <4C585BC8.5070203@goop.org>
In-Reply-To: <4C585BC8.5070203@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/03/2010 11:11 AM, Jeremy Fitzhardinge wrote:
>  Hi Dave,
>
> Here's a git branch with some updates to the Xen netfront driver, 
> which add a new "smartpoll" mode to the netfront backend protocol, 
> which is basically equivalent to interrupt mitigation.  They've been 
> in linux-next for a week or so.

Oops, never mind.

They got left out of linux-next, and they have a merge conflict.  I'll 
sort it out and resubmit.

'Thanks,
     J

