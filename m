Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab0CYVsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 17:48:21 -0400
Received: from crca.org.au ([74.207.252.120]:49783 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab0CYVsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 17:48:20 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BABDA59.8070107@crca.org.au>
Date: Fri, 26 Mar 2010 08:49:13 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100301 Shredder/3.0.4pre
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jslaby@suse.cz>, jirislaby@gmail.com,
       linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] what the patches do Re: [RFC 10/15] PM / Hibernate:
 user, implement user_ops reader
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz>	<201003252114.36605.rjw@sisk.pl> <4BABC5B6.2070301@crca.org.au>	<201003252129.10224.rjw@sisk.pl> <20100325212656.GD22902@elf.ucw.cz>
In-Reply-To: <20100325212656.GD22902@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 26/03/10 08:26, Pavel Machek wrote:
> Hi!
>
>>>>> I'm asking because if we're going to make a go of getting the in-kernel
>>>>> code in much better shape, and we have Rafael, Jiri and I - and you? -
>>>>> all pulling in the same direction to improve it, there's going to come a
>>>>> point (hopefully not too far away) where uswsusp is just making life too
>>>>> difficult, and getting rid of it will be a big help.
>>>>
>>>> We're not dropping user space interfaces used by every distro I know of.
>
> Good.
>
>>> So what's your long term plan then?
>>
>> First, improve the in-kernel thing, second, switch people to it, _then_ remove
>> the s2disk interface (after we're reasonably sure it's not used by any major
>> distro) and _finally_ simplify things after it's been removed.
>
> I'd really prefer to keep s2disk interface. It allows advanced stuff
> like internet suspend resume (yep someone is doing it), crazy stuff
> like multiple resumes from same image for fast booting (yep, some
> embedded people are doing that) and might-be-useful stuff like
> s2both...

Neither of those are impossible with in-kernel code, so I'd argue that 
there's no need to keep the s2disk interface long-term. Userspace 
helpers might be necessary for the first one (to manage the network 
interface), but I already have multiple-resumes-from-the-same-image 
support in TuxOnice (and more 'crazy stuff' like support for resuming a 
different image after writing one - that can be used to switch to an 
initramfs containing the binaries needed to power down a UPS).

Regards,

Nigel
