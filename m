Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab0JAVpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 17:45:45 -0400
Received: from tuxonice.net ([74.207.252.127]:38651 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab0JAVpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 17:45:44 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4CA65684.1050500@tuxonice.net>
Date: Sat, 02 Oct 2010 07:45:40 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10pre) Gecko/20100903 Shredder/3.1.4pre
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [PATCH 01/23] Hibernation: Split compression support out.
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net> <201009272227.42779.rjw@sisk.pl> <4CA0FF42.2020608@tuxonice.net> <201010012328.09892.rjw@sisk.pl>
In-Reply-To: <201010012328.09892.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael.

On 02/10/10 07:28, Rafael J. Wysocki wrote:
> On Monday, September 27, 2010, Nigel Cunningham wrote:
>> Hi.
>>
>> On 28/09/10 06:27, Rafael J. Wysocki wrote:
>>> On Monday, September 27, 2010, Nigel Cunningham wrote:
> ...
>>> This one doesn't really good to me.  What I'd prefer would be to have a
>>> structure of "swap operations" pointers like ->start(), ->write_data(),
>>> ->read_data(), and ->finish() that will point to the functions in this file
>>> (if compression is to be used) or to the "old" swap_write_page()/swap_read_page()
>>> otherwise.  That would reduce the number of the
>>> (flags&   SF_NOCOMPRESS_MODE) checks quite substantially and will likely result
>>> in code that's easier to follow.
>>
>> Me too. I was heading in that direction, but not doing it in one step.
>> I'll happily change that.
>
> I'm still waiting for the reworked patch.  If you can submit it in a few days
> and it looks good, I'll include it into the pull request for 2.6.37.

Sorry for the delay.

Would you be happy if, rather than reworking that patch and modifying 
other patches that are affected, I added a new patch to the end of the 
series?

Regards,

Nigel
