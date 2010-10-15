Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab0JOTdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:33:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:41906 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756242Ab0JOTdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:33:35 -0400
Message-ID: <4CB8AC80.7090802@kernel.org>
Date: Fri, 15 Oct 2010 21:33:20 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Christian Lamparter <chunkeey@googlemail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2.6.36-rc7] mac80211: cancel restart_work explicitly
 instead of depending on flush_scheduled_work()
References: <4CB874C0.8090003@kernel.org> <1287159715.1870.11.camel@Nokia-N900-51-1> <4CB883C9.6050104@kernel.org> <201010151858.45000.chunkeey@googlemail.com> <20101015192645.GA2438@tuxdriver.com>
In-Reply-To: <20101015192645.GA2438@tuxdriver.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 19:33:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/15/2010 09:26 PM, John W. Linville wrote:
>> wireless-testing/wireless-next has already such a patch:
>> "mac80211: cancel restart_work in ieee80211_unregister_hw" (2010-08-25)
>>
>> <http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git;a=commit;h=258086a48b766d12a500f98834654ffa927ca475>
>>
>> John, can you please push to 2.6.36-rc8?
>> (I know, I am _late_, but I didn't know about any potential problem
>> in the mainline?)
> 
> I don't see how either patch would merit inclusion in 2.6.36 at this point.

My patch definitely was aimed for 2.6.37-rc1 or later.  I'm not sure
whether the cancel_work_sync() is a bug fix or not but if it hasn't
actually triggered yet, I guess leaving it as-is isn't too bad at this
point.

Thanks.

-- 
tejun
