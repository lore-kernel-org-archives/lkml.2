Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0CYOaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:30:08 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38565 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753338Ab0CYOaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:30:06 -0400
Date: Thu, 25 Mar 2010 15:29:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC 03/15] PM / Hibernate: separate block_io
Message-ID: <20100325142943.GA1657@ucw.cz>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <1269361063-3341-3-git-send-email-jslaby@suse.cz> <20100324203021.GE5798@elf.ucw.cz> <4BAA829F.7060207@gmail.com> <4BAA98FC.9040302@crca.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAA98FC.9040302@crca.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-03-25 09:58:04, Nigel Cunningham wrote:
> Hi.
>
> On 25/03/10 08:22, Jiri Slaby wrote:
>> On 03/24/2010 09:30 PM, Pavel Machek wrote:
>>> On Tue 2010-03-23 17:17:31, Jiri Slaby wrote:
>>>> +int sws_bio_read_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
>>>> +{
>>>> +	return submit(READ, sws_resume_bdev, page_off * (PAGE_SIZE>>  9),
>>>> +			virt_to_page(addr), bio_chain);
>>>> +}
>>>
>>> sws_ is kind of strange prefix. We were trying to get away from
>>> "swsuspend" name for quite some time...
>>
>> No problem to change the prefix to anything else. Do you (anybody)
>> suggest anything?
>>
>
> How about some abbreviation of hibernate? "hib"?

hib_ certainly sounds better.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
