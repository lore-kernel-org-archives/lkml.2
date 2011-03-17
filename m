Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab1CQMEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 08:04:55 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47457 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab1CQMEx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 08:04:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lOfeZr/lycdAU9JwW5xxlQFrHNyR/3p3FwOmS1pL6xiIDhvr9MJov219ZY2ea0ScFy
         mRLNm7VUNZwFBF84lyByLH1EkrZq+tgXTQfJUTpl4p1ecKhVbyVR1LoeCYNgt23fRCmy
         PeDxfkX0jiSpKeC9MCAHR3pQfdsH2Q0clq7SE=
MIME-Version: 1.0
In-Reply-To: <20110316115439.6e036e75@lxorguk.ukuu.org.uk>
References: <AANLkTimP9-SK3YCwgsS8USEYNExFQTQLPYXKi+RUbBT4@mail.gmail.com>
	<20110316115439.6e036e75@lxorguk.ukuu.org.uk>
Date: Thu, 17 Mar 2011 17:34:52 +0530
Message-ID: <AANLkTikaBU2hNNfBK7HFjB_imM+85VHNSOa6xPjjVuSX@mail.gmail.com>
Subject: Re: Query
From: snmp snmp <snmp.ml@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot for replying and your suggestions.
Actually , we have implemented this on SMP architecture.
We are trying to measure the performance with the tool you have suggested.


On Wed, Mar 16, 2011 at 5:24 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>      Me and my friends are working on a new concept.
>
> It's not really new. Various systems have done this historically, and
> folks including Larry McVoy have proposed that for large scalability you
> might build a system out of multiple separate kernels one on each NUMA
> node and which had interfaces to loan or share pages with one another by
> bumping page counts and handling coherency.
>
> Cool to see someone trying some of this in Linux
>
>>      Our implementation is on Intel core 2 duo machine. So far our
>> implementation includes running two kernels simultaneously (one on
>> each core) , handling hard-disk on one core and ethernet on another
>> core so as to divide the network and disk subsystem.
>>
>>      But here we are unable to measure the performance. Can u please
>> suggest any method to measure the performance in terms of throughput
>> and response time?
>
> There are a bunch of standard benchmarks you can use. A lot of the big
> name ones need clusters of systems to do the loading but there are things
> like dbench that are quite useful on single systems.
>
> For some of the applications you are talking about I think dbench might
> be a good start.
>
>
> Alan
>
