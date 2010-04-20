Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab0DTKOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 06:14:10 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38035 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab0DTKOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 06:14:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DOG5FcO1Jt5vfbbBt/bjzzZCjYxlwloDdRykJd1mVhEPfizuMTX7yQipcvBcTAYe8z
         Kf/6/Z5MYzwpfUn1P+Wk7yYmmdNc40wzB7t9rAVv3LpFjuY1YmS29pQPMn3aL6JKMZEr
         mGsPzAXTjSNyTDpuH9r5x6tomxJRcJgHATQOk=
MIME-Version: 1.0
In-Reply-To: <20100420095855.GE19264@csn.ul.ie>
References: <201004152210.o3FMA7KV001909@imap1.linux-foundation.org>
	 <20100419190133.50a13021.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100419181442.GA19264@csn.ul.ie> <20100419193919.GB19264@csn.ul.ie>
	 <s2v28c262361004191939we64e5490ld59b21dc4fa5bc8d@mail.gmail.com>
	 <20100420082057.GC19264@csn.ul.ie>
	 <x2h28c262361004200132q39fe5d5ex79251643a80d28b3@mail.gmail.com>
	 <20100420084454.GD19264@csn.ul.ie>
	 <x2u28c262361004200250h2c38894i9adbd85d8fb7b1d8@mail.gmail.com>
	 <20100420095855.GE19264@csn.ul.ie>
Date: Tue, 20 Apr 2010 19:14:05 +0900
Message-ID: <p2m28c262361004200314i43af7c2bob94ee64d912ae2c1@mail.gmail.com>
Subject: Re: error at compaction (Re: mmotm 2010-04-15-14-42 uploaded
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 6:58 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Tue, Apr 20, 2010 at 06:50:23PM +0900, Minchan Kim wrote:
>> On Tue, Apr 20, 2010 at 5:44 PM, Mel Gorman <mel@csn.ul.ie> wrote:
>> > On Tue, Apr 20, 2010 at 05:32:13PM +0900, Minchan Kim wrote:
>> >>
>> >> Yes. Then, Let's add comment like split_page. :)
>> >>  /*
>> >>  * Note: this is probably too low level an operation for use in drivers.
>> >>  * Please consult with lkml before using this in your driver.
>> >>  */
>> >>
>> >
>> > I can, but the comment that was there says it's like split_page except the
>> > page is already free. This also covers not using it in a driver.
>>
>> I see. In addition, you already mentioned "As this is only being used
>> for migration".
>> I missed one.
>> I don't have any against one.
>> Will you repost v2 which move split_free_pages out of compaction.c?
>
> I don't understand your suggestion. split_free_pages is already out of
> compaction.c.

Ahh. Sorry. It's my fault. I confused. forget it, please.
-- 
Kind regards,
Minchan Kim
