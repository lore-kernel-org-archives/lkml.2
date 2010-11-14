Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab0KNVlp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 16:41:45 -0500
Received: from smtp171.iad.emailsrvr.com ([207.97.245.171]:58347 "EHLO
	smtp171.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757020Ab0KNVlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 16:41:44 -0500
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Nov 2010 16:41:44 EST
Message-ID: <4CE055A4.5010403@aljex.com>
Date: Sun, 14 Nov 2010 16:33:24 -0500
From: "Brian K. White" <brian@aljex.com>
Organization: Aljex Software Inc.
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: rsync@lists.samba.org
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: fadvise DONTNEED implementation (or lack thereof)
References: <20101109162525.BC87.A69D9226@jp.fujitsu.com>	<877hgmr72o.fsf@gmail.com>	<20101114140920.E013.A69D9226@jp.fujitsu.com> <87y68wiipy.fsf@gmail.com>
In-Reply-To: <87y68wiipy.fsf@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2010 12:20 AM, Ben Gamari wrote:
> On Sun, 14 Nov 2010 14:09:29 +0900 (JST), KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>  wrote:
>> Because we have an alternative solution already. please try memcgroup :)
>>
> Alright, fair enough. It still seems like there are many cases where
> fadvise seems more appropriate, but memcg should at least satisfy my
> personal needs so I'll shut up now. Thanks!
>
> - Ben

Could someone expand on this a little?

The "there are no users of this feature" argument is indeed a silly one. 
I've only wanted the ability to perform i/o without poisoning the cache 
since oh, 10 or more years ago at least. It really hurts my users since 
they are all direct login interactive db app users. No load balancing 
web interface can hide the fact when a box goes to a crawl.

How would one use memcgroup to prevent a backup or other large file 
operation from wiping out the cache with used-once garbage?

(note for rsync in particular, how does this help rsync on other platforms?)

-- 
bkw
