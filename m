Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab0ERFJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 01:09:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33516 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab0ERFJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 01:09:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MfpLmGj1I8kW8NcRqg/LK6OW3DD8/p5840Z/QXRrv+UChEygQWm4cPZvD+isS1g4bu
         AOEwicMtcgyIKS3GYS7ZA/bHHTsxiA5V4jl98pE3plHtl1QPyxgZJiYYDHuXzYNg2Q3b
         nUS4/VVr92zLe5IqQ+Pr1Pmj9imp6t7FRTW1M=
Message-ID: <4BF220EB.1020300@gmail.com>
Date: Mon, 17 May 2010 22:08:59 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: senthilkumaar2021 <senthilkumaar2021@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: kernel panic
References: <4BF21646.60008@gmail.com> <4BF21BD3.60901@gmail.com> <4BF21DAD.6050609@gmail.com>
In-Reply-To: <4BF21DAD.6050609@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2010 09:55 PM, senthilkumaar2021 wrote:
> Hi
>
> Thanks for the reply
>
> Initially i was using kernel 2.6.28.5 and kernel panic occurred in that
> version too
>
> tproxy is not supported in linux 2.6.32
>
> http://wiki.squid-cache.org/Features/Tproxy4
>
> kindly guide me how to proceed
>
> Regards
> senthil
>


hmm.. I'm wondering if this should be discussed here then.
In any case do you receive this error with 2.6.30
(even though 2.6.28 gives you this)

if so then doing a bisect might be a bit hard todo.
(unless 2.6.30 is good, then a bisect can at-least
point you in the right direction with what might be happening).

Justin P. Mattock

