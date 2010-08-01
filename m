Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab0HARxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 13:53:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48937 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab0HARxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 13:53:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KFiw0RXZN+qjlrdHmcN7zfoyciRqHWA4MFyxXvLO6OXIcgLIfn9F2OepttUFxKkq3f
         L7qWT/OO2KKq1b0Qj4E6YSmw288En9zjOmrZQaChzkBHM8fdxtfipT/Yhhj4THNM3R9B
         BYl2fkmmQtsbTb+6Xj7S9mh0WvgpcmMzdZkgs=
Message-ID: <4C55B4AE.8020700@gmail.com>
Date: Sun, 01 Aug 2010 10:53:50 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        ksummit-2010-discuss@lists.linux-foundation.org
Subject: Re: PSA: Please update your flash plugin!
References: <E1OefgE-0005vu-JN@tytso-glaptop> <4C524F7A.20505@gmail.com> <4C558237.1040705@panasas.com>
In-Reply-To: <4C558237.1040705@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2010 07:18 AM, Boaz Harrosh wrote:
> On 07/30/2010 07:05 AM, Justin P. Mattock wrote:
>> On 07/29/2010 07:50 PM, Theodore Ts'o wrote:
>>> This is a public service announcement --- if you are running Flash 10.0,
>>> make sure you upgrade to 10.1.  Flash 10.0 has a horrible security
>>> vulnerability:
>>>
>>> 	http://www.adobe.com/support/security/bulletins/apsb10-14.html
>>>
>>> I have Google Analytics running on the ksummit2010 website, and in
>>> addition to discovering that 59% used Firefox and 25% were using Chrome,
>>> and that the most popular screen resolution was 1280x800 followed by
>>> 1280x1024, etc. --- I also was able to find that while 59% were running
>>> Flash 10.1, over 40% of the visitors to the ksummit2010 web site were
>>> running a vulnerable version of Adobe flash, which has a remote code
>>> execution vulerability.
>>>
>>> If you were visiting that site from your development system, which you
>>> use to push changes to a subsystem maintianer, or even Linus, hopefully
>>> I don't need to tell you what a bad idea it is to leave yourself open
>>> and vulnerable like this.  (This particular security problem with Flash
>>> has been announced for almost 2 months at this point!)
>>>
>>> 						- Ted
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
>>
>> biggest problem here is they havn't updated their x86_64(pure64) version
>> yet. hopefully hey release an update soon.
>>
>> Justin P. Mattock
>> --
>
> Here too. How do I run (any) Flash-10.1 on a 64bit system (say FC12) without
> actually reverting to a 32bit browser? Do I still get to install half of my
> system as 32bit duplicates?
>
> Boaz
>


right now I decided to just run the 32bit flash through qemu-kvm either 
a windows install or an x86_32 linux distro this way I can watch hulu 
stream TV etc..

Justin P. Mattock
