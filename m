Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab2FJDVv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 23:21:51 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:47981 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2FJDVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 23:21:49 -0400
Message-ID: <4FD412CB.9060809@gmail.com>
Date: Sat, 09 Jun 2012 23:21:47 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, kosaki.motohiro@gmail.com
Subject: Re: oomkillers gone wild.
References: <20120604152710.GA1710@redhat.com> <alpine.DEB.2.00.1206041629500.7769@chino.kir.corp.google.com> <20120605174454.GA23867@redhat.com> <alpine.DEB.2.00.1206081313000.19054@chino.kir.corp.google.com> <20120608210330.GA21010@redhat.com> <alpine.DEB.2.00.1206091920140.7832@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1206091920140.7832@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(6/9/12 10:21 PM), David Rientjes wrote:
> On Fri, 8 Jun 2012, Dave Jones wrote:
>
>>   >  On a system not under oom conditions, i.e. before you start trinity, can
>>   >  you send the output of
>>   >
>>   >  	cat /proc/$(pidof dbus-daemon)/oom_score{_adj,}
>>   >  	grep RSS /proc/$(pidof dbus-daemon)/status
>>
>> # cat /proc/$(pidof dbus-daemon)/oom_score{_adj,}
>> -900
>> 7441500919753
>> # grep RSS /proc/$(pidof dbus-daemon)/status
>> VmRSS:	    1660 kB
>
> I'm suspecting you don't have my patch that changes the type of the
> automatic variable in oom_badness() to signed.  Could you retry this with
> that patch or pull 3.5-rc2 which already includes it?

Yes. Dave (Jones), As far as parsed your log, you are using x86_64, right?
As far as my testing, current linus tree works fine at least normal case.
please respin.
