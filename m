Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab2DCW0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 18:26:36 -0400
Received: from uhura.skim.hs-owl.de ([193.174.118.81]:35254 "EHLO
	uhura.skim.hs-owl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab2DCW0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 18:26:34 -0400
Message-ID: <4F7B7911.5090307@googlemail.com>
Date: Wed, 4 Apr 2012 00:26:25 +0200
From: Jan Seiffert <kaffeemonster@googlemail.com>
Reply-To: <kaffeemonster@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120327 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION][PATCH V4 1/3] bpf jit: Make the filter.c::__load_pointer
 helper non-static for the jits
References: <4F75CA89.4010709@googlemail.com> <4F75CC63.10405@googlemail.com> <20120403.180212.1644422418766062447.davem@davemloft.net>
In-Reply-To: <20120403.180212.1644422418766062447.davem@davemloft.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Skim-SendBy: exchange.hs-owl.de on Wed, 04 Apr 2012 00:26:30 +0200
X-Skim-SendBy: exchange.hs-owl.de on Wed, 04 Apr 2012 00:26:31 +0200
X-SA-Exim-Connect-IP: 193.174.118.178
X-SA-Exim-Mail-From: kaffeemonster@googlemail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller schrieb:
> From: Jan Seiffert <kaffeemonster@googlemail.com>
> Date: Fri, 30 Mar 2012 17:08:19 +0200
> 
>> The function is renamed to make it a little more clear what it does.
>> It is not added to any .h because it is not for general consumption, only for
>> bpf internal use (and so by the jits).
>>
>> Signed-of-by: Jan Seiffert <kaffeemonster@googlemail.com>
> 
> Applied but with comment formatting fixed up:
> 
>> +/*
>> + * No hurry in this branch
>> + *
>> + * Exported for the bpf jit load helper.
>> + */
> 
> Like this:
> 
>> +/* No hurry in this branch
>> + *
>> + * Exported for the bpf jit load helper.
>> + */
> 

Thanks David!

I was planning on a V5 for the little things i did wrong (wrong patch
separator, etc.) but wanted to wait a little more for more feedback.

Is that the preferred comment style in net/ ? Coding style says
first line empty. Or just to match the rest of the file?

Greetings
	Jan
