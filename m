Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab1AZHk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:40:29 -0500
Received: from nm12-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.246]:38261
	"HELO nm12-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751223Ab1AZHk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:40:28 -0500
X-Yahoo-Newman-Id: 423483.72742.bm@omp1023.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:Content-Type:Content-Transfer-Encoding;
  b=jg0fsAXgXeaYfgQjgEZyVc1k+qNCREErdUP7KA8B9KeCU3o+j3CirN6MvZs54pMQrtToC/Hq38y0BurWzVZrleMwJn/9JzK+A+UdXvaWpn2TzE5TzlJqTLZzo6TDwC6hP2013yqymSvgfuL8GgRZHXYQwnyjZm1CWdGFiWFdyRM=  ;
X-Yahoo-SMTP: zgdcvJ6swBBcTOk5fgveL37ak9AQxYCP7GdO
X-YMail-OSG: xfe82ygVM1lkamDYQLprJJJcB0fTVoT2BozmKlgSrrqV6yT
 MN39cBzrU4HIJRnkaMNaTQijKaBp8XBh4ai3ZxkGXToTWmrTN8VKNRKZxmfR
 X1v0BD1_DfjuKgwHKIX1IHBBafB_ZBpBCugHLhKXSuxc8kn_h2zY3csjhqc_
 CmENElY6dRXuKzzxPeYZm8FNqLVFeakJiPvuL0IpahNpOVy63Vj7wS4JgSLT
 54zmAhzhuF0Xi34i4JgtJsrZLMQY5cYUmyqXX
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4D3FD00D.2040303@yahoo.fr>
Date: Wed, 26 Jan 2011 08:41:01 +0100
From: Lionel Debroux <lionel_debroux@yahoo.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100131 Thunderbird/3.0.1
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, rjw@sisk.pl,
        colin.king@canonical.com
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus
 laptops)
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com> <4D3DDDA4.2080202@yahoo.fr> <alpine.LFD.2.02.1101242154090.6097@x980>
In-Reply-To: <alpine.LFD.2.02.1101242154090.6097@x980>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> * 2.6.35 series: .4 and .6 boot successfully, .8 and .10 fail;
>>>>> * 2.6.36 series: -rc2 boots successfully, .1 fails;
>>>>> * 2.6.37 series: -rc4 fails.
>>>>
>>>> So it's probably a commit to the mainline tree which was picked
>>>> by 2.6.35 maintainer to the stable tree (probably it was CC'ed)
>>>> cause this.
>>>>
>>>> Does passing nolapic or acpi=off cures the issue?
>>> IIRC, I tested at least one of these, without improvement.
>>> I'll test again tonight, when I can physically access the
>>> computer.
>> None of nolapic, acpi=off, nolapic acpi=off enables 2.6.35.8 to
>> boot on my ASUS F3Jv-AS022P.
>> The kernel line is
>> kernel /boot/vmlinuz root=/dev/sda9 nomce vga=791 nomodeset
>> I've attached the 2.6.35.6 config.
> 
> looks like you've bisected as far as:
> 2.6.35.6 good
> 2.6.35.8 bad
> 
> can you try 2.6.35.7 and continue on to find which specific patch
> in .stable broke your machine?
The bisection between 2.6.35.6 and 2.6.35.8 is in progress, two steps
left and no good kernel found yet (?!)
Due to not having physical access to the computer during work time, I
won't be able to finish until tonight.


Regards,
Lionel.
