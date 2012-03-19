Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab2CSUuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:50:03 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52156 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab2CSUuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:50:00 -0400
Message-ID: <4F679BF2.7040107@jp.fujitsu.com>
Date: Mon, 19 Mar 2012 16:49:54 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: dledford@redhat.com
CC: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        amwang@redhat.com, jslaby@suse.cz, ebiederm@xmission.com,
        joe.korty@ccur.com, dhowells@redhat.com
Subject: Re: [resend][PATCH 1/3] mqueue: revert bump up DFLT_*MAX
References: <79ac1725-6aa2-4d67-8b59-cbf752ea9f3e@zmail13.collab.prod.int.phx2.redhat.com>
In-Reply-To: <79ac1725-6aa2-4d67-8b59-cbf752ea9f3e@zmail13.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/19/2012 2:16 PM, Doug Ledford wrote:
> ----- Original Message -----
>> On 3/14/2012 5:45 PM, Doug Ledford wrote:
>>> On 03/14/2012 05:38 PM, Andrew Morton wrote:
>>>> On Wed, 14 Mar 2012 17:28:33 -0400
>>>> Doug Ledford <dledford@redhat.com> wrote:
>>>>
>>>>> This has obviously fallen through the cracks.
>>>>
>>>> It sure has.  Please dig out whatever is the currently favored
>>>> patchset, refresh, retest and resend, with changelogging which
>>>> fully
>>>> covers the reasoning and decision process?
>>>
>>> OK, completely redoing patch set then against current Linus tree.
>>>
>>> Motohiro, would you be so kind as to resend my your patches that
>>> went on
>>> top of mine and I'll create a complete patch set?
>>
>> I'm sorry. I already have a rebased patch. but I haven't posted. I
>> have toa
>> hurry.
> 
> Actually, I already pulled them from the lkml archives and fixed up
> the one patch that didn't apply cleanly.  The only reason I haven't
> sent the entire patchset out yet is that I'm writing a test/verification
> app to go along with it.

OK, I'll stop this work then. Good luck. :)

But, please rebase the patch on top linux-next. It's more akpm happy and
you are going to see more conflicts. That's the reason why I thought I
need more tests.

