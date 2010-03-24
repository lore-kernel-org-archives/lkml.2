Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab0CXW5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 18:57:14 -0400
Received: from crca.org.au ([74.207.252.120]:37006 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab0CXW5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 18:57:12 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BAA98FC.9040302@crca.org.au>
Date: Thu, 25 Mar 2010 09:58:04 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100301 Shredder/3.0.4pre
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC 03/15] PM / Hibernate: separate block_io
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <1269361063-3341-3-git-send-email-jslaby@suse.cz> <20100324203021.GE5798@elf.ucw.cz> <4BAA829F.7060207@gmail.com>
In-Reply-To: <4BAA829F.7060207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 25/03/10 08:22, Jiri Slaby wrote:
> On 03/24/2010 09:30 PM, Pavel Machek wrote:
>> On Tue 2010-03-23 17:17:31, Jiri Slaby wrote:
>>> +int sws_bio_read_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
>>> +{
>>> +	return submit(READ, sws_resume_bdev, page_off * (PAGE_SIZE>>  9),
>>> +			virt_to_page(addr), bio_chain);
>>> +}
>>
>> sws_ is kind of strange prefix. We were trying to get away from
>> "swsuspend" name for quite some time...
>
> No problem to change the prefix to anything else. Do you (anybody)
> suggest anything?
>

How about some abbreviation of hibernate? "hib"?

Regards,

Nigel
