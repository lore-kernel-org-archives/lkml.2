Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab2EDBuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 21:50:39 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49211 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab2EDBui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 21:50:38 -0400
Date: Thu, 03 May 2012 21:50:20 -0400 (EDT)
Message-Id: <20120503.215020.954262287222794218.davem@davemloft.net>
To: namhyung.kim@lge.com
Cc: gregkh@linuxfoundation.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@ghostprotocols.net, jolsa@redhat.com,
        lacombar@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: perf build failure on Linus's tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <87sjfgafqj.fsf@sejong.aot.lge.com>
References: <20120503215748.GA18995@kroah.com>
	<87sjfgafqj.fsf@sejong.aot.lge.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 03 May 2012 18:50:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q441oib8032314

From: Namhyung Kim <namhyung.kim@lge.com>
Date: Fri, 04 May 2012 10:37:24 +0900

> Hi,
> 
> On Thu, 3 May 2012 14:57:48 -0700, Greg KH wrote:
>> Linus's tree right now (3.4.rc5.67.gac001.dirty) gives me the following
>> build error when I try to build perf:
>>     CC util/parse-events-flex.o
>> <stdout>: In function ¡yy_get_next_buffer¢:
>> <stdout>:1510:3: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]
>> util/parse-events.l: In function ¡parse_events_lex¢:
>> util/parse-events.l:122:1: error: ignoring return value of ¡fwrite¢, declared with attribute warn_unused_result [-Werror=unused-result]
>> cc1: all warnings being treated as errors
>>
>> Do you really want to ensure that flex's build warnings fail the build?
>>
>> thanks,
>>
>> greg k-h
> 
> Can't reproduce it on my Fedora 17 box:

Because your glibc headers probably don't have the warn_unused_result attribute
in the extern declaration of fwrite() like Greg's do.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
