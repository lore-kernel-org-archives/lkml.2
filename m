Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629Ab0FEXBs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 19:01:48 -0400
Received: from crca.org.au ([74.207.252.120]:49850 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933511Ab0FEXBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 19:01:47 -0400
X-Bogosity: Ham, spamicity=0.000348
Message-ID: <4C0AD754.7060800@crca.org.au>
Date: Sun, 06 Jun 2010 09:01:40 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Theodore Tso <tytso@MIT.EDU>
CC: Pavel Machek <pavel@ucw.cz>, pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [TuxOnIce-devel] [SUSPECTED SPAM] Re: [linux-pm] Proposal for
 a new algorithm for reading & writing a hibernation image.
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com> <4C0994B9.6070406@crca.org.au> <88D03BC9-5E85-482D-9431-F1CE4C958C9B@mit.edu>
In-Reply-To: <88D03BC9-5E85-482D-9431-F1CE4C958C9B@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 05/06/10 22:59, Theodore Tso wrote:
>
> On Jun 4, 2010, at 8:05 PM, Nigel Cunningham wrote:
>>> 2mb pages will probably present a problem, as will bat mappings on powerpc.
>>
>> I have the idea that 2MB pages are only used for the kernel text and read only data. Is that right? If so, perhaps they can just be unconditionally copied (so that we can restore the image if a different kernel is booted) and wouldn't need any page protection. Does that sound right?
>
> No, hugepages are available for use by userspace programs.
>
> See: https://lwn.net/Articles/374424/

Ta!

I'll take a look.

Nigel
