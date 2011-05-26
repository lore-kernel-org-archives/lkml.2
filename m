Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab1EZIS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 04:18:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51616 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab1EZISy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 04:18:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDE0CDD.5050000@jp.fujitsu.com>
Date: Thu, 26 May 2011 17:18:37 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: luto@mit.edu
CC: minchan.kim@gmail.com, aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com,
        fengguang.wu@intel.com, andi@firstfloor.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, hannes@cmpxchg.org,
        riel@redhat.com
Subject: Re: Easy portable testcase! (Re: Kernel falls apart under light memory
 pressure (i.e. linking vmlinux))
References: <BANLkTinptn4-+u+jgOr2vf2iuiVS3mmYXA@mail.gmail.com>
In-Reply-To: <BANLkTinptn4-+u+jgOr2vf2iuiVS3mmYXA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/26 5:17), Andrew Lutomirski wrote:
> On Tue, May 24, 2011 at 8:43 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
>>
>> Unfortnately, this log don't tell us why DM don't issue any swap io. ;-)
>> I doubt it's DM issue. Can you please try to make swap on out of DM?
>>
>>
> 
> I can do one better: I can tell you how to reproduce the OOM in the
> comfort of your own VM without using dm_crypt or a Sandy Bridge
> laptop.  This is on Fedora 15, but it really ought to work on any
> x86_64 distribution that has kvm.  You'll probably want at least 6GB
> on your host machine because the VM wants 4GB ram.

Hmmm....

I don't have 6GB memory. :-)
I'll try to borrow it from anywhere, but I'd expect my response is delayed
some time.

