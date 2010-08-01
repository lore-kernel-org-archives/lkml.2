Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab0HAOSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 10:18:36 -0400
Received: from daytona.panasas.com ([67.152.220.89]:58492 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754504Ab0HAOSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 10:18:34 -0400
Message-ID: <4C558237.1040705@panasas.com>
Date: Sun, 01 Aug 2010 17:18:31 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        ksummit-2010-discuss@lists.linux-foundation.org
Subject: Re: PSA: Please update your flash plugin!
References: <E1OefgE-0005vu-JN@tytso-glaptop> <4C524F7A.20505@gmail.com>
In-Reply-To: <4C524F7A.20505@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Aug 2010 14:18:33.0655 (UTC) FILETIME=[6C88F470:01CB3184]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2010 07:05 AM, Justin P. Mattock wrote:
> On 07/29/2010 07:50 PM, Theodore Ts'o wrote:
>> This is a public service announcement --- if you are running Flash 10.0,
>> make sure you upgrade to 10.1.  Flash 10.0 has a horrible security
>> vulnerability:
>>
>> 	http://www.adobe.com/support/security/bulletins/apsb10-14.html
>>
>> I have Google Analytics running on the ksummit2010 website, and in
>> addition to discovering that 59% used Firefox and 25% were using Chrome,
>> and that the most popular screen resolution was 1280x800 followed by
>> 1280x1024, etc. --- I also was able to find that while 59% were running
>> Flash 10.1, over 40% of the visitors to the ksummit2010 web site were
>> running a vulnerable version of Adobe flash, which has a remote code
>> execution vulerability.
>>
>> If you were visiting that site from your development system, which you
>> use to push changes to a subsystem maintianer, or even Linus, hopefully
>> I don't need to tell you what a bad idea it is to leave yourself open
>> and vulnerable like this.  (This particular security problem with Flash
>> has been announced for almost 2 months at this point!)
>>
>> 						- Ted
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> 
> biggest problem here is they havn't updated their x86_64(pure64) version 
> yet. hopefully hey release an update soon.
> 
> Justin P. Mattock
> --

Here too. How do I run (any) Flash-10.1 on a 64bit system (say FC12) without
actually reverting to a 32bit browser? Do I still get to install half of my
system as 32bit duplicates?

Boaz
