Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab2IWFj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 01:39:26 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46442 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab2IWFjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 01:39:25 -0400
Message-ID: <505EA09B.6040105@gmail.com>
Date: Sun, 23 Sep 2012 07:39:39 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Michael Wang <wangyun@linux.vnet.ibm.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        fweisbec@gmail.com
Subject: Re: RCU idle CPU detection is broken in linux-next
References: <20120921121346.GD2458@linux.vnet.ibm.com> <505C6B03.7020305@gmail.com> <20120921151203.GA2454@linux.vnet.ibm.com> <505C855F.3060301@gmail.com> <505D7621.4040505@gmail.com> <20120922150913.GA2934@linux.vnet.ibm.com> <505DDBE7.7010706@gmail.com> <20120922155613.GB2934@linux.vnet.ibm.com> <505DFA65.3080805@gmail.com> <20120922212735.GG2934@linux.vnet.ibm.com> <20120923002105.GA1112@linux.vnet.ibm.com>
In-Reply-To: <20120923002105.GA1112@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2012 02:21 AM, Paul E. McKenney wrote:
> On Sat, Sep 22, 2012 at 02:27:35PM -0700, Paul E. McKenney wrote:
>> On Sat, Sep 22, 2012 at 07:50:29PM +0200, Sasha Levin wrote:
>>> On 09/22/2012 05:56 PM, Paul E. McKenney wrote:
>>>> And now the prime suspect is the new CONFIG_RCU_USER_QS=y.  Do these
>>>> warnings ever show up with CONFIG_RCU_USER_QS=n?
>>>
>>> It seems that disabling that does make the warnings go away.
>>>
>>> I'll keep the tests running in case it just reduces the chances or something
>>> like that.
>>
>> Thank you for testing this!
>>
>> And of course the reason that I didn't see these problems is that I
>> failed to update my tests to enable CONFIG_RCU_USER_QS.  :-/
> 
> Also the fact that I run 32-bit guests on x86.  Sigh!
> 
> I take it that you are running 64-bit guests?

Yes, that's correct.


Thanks,
Sasha

