Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab0FGFbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 01:31:46 -0400
Received: from crca.org.au ([74.207.252.120]:53196 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab0FGFbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 01:31:45 -0400
X-Bogosity: Ham, spamicity=0.002941
Message-ID: <4C0C843D.6030008@crca.org.au>
Date: Mon, 07 Jun 2010 15:31:41 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [SUSPECTED SPAM] Re: Proposal for a new algorithm
 for reading & writing a hibernation image.
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com>	<201006061557.20482.rjw@sisk.pl>	<1275839650.5331.2.camel@maxim-laptop> <201006062104.55869.rjw@sisk.pl>
In-Reply-To: <201006062104.55869.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 07/06/10 05:04, Rafael J. Wysocki wrote:
> On Sunday 06 June 2010, Maxim Levitsky wrote:
>> On Sun, 2010-06-06 at 15:57 +0200, Rafael J. Wysocki wrote:
>>> On Sunday 06 June 2010, Maxim Levitsky wrote:
> ...
>>> So how TuxOnIce helps here?
>> Very simple.
>>
>> With swsusp, I can save 750MB (memory) + 250 Vram (vram)
>> With full memory save I can save (1750 MB of memory) + 250 MB of
>> vram....
>
> So what about being able to save 1600 MB total instead of the 2 GB
> (which is what we're talking about in case that's not clear)?  Would it
> be _that_ _much_ worse?

That all depends on what is in the 400MB you discard.

The difference is "Just as if you'd never hibernated" vs something 
closer to "Just as if you'd only just started up". We can't make 
categorical statements because it really does depend upon what you 
discard and what you want to do post-resume - that is, how useful the 
memory you discard would have been. That's always going to vary from 
case to case.

Regards,

Nigel
