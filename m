Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2GXVvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 17:51:40 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58743 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2GXVvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 17:51:39 -0400
Message-ID: <500F18E7.2040809@suse.cz>
Date: Tue, 24 Jul 2012 23:51:35 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120718 Thunderbird/15.0
MIME-Version: 1.0
To: tingwei liu <tingw.liu@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        dhillf@gmail.com
Subject: Re: Suse 11 SP1 kernel panic on HP hardware
References: <CA+qZnSRNAAN6erat3Umuk6U9VYuc5SiQYK6PL8bHYAOcQ+SnAw@mail.gmail.com> <CA+qZnSS2N4QZ13qATNFCbhJ6BRy4ZfpEBur45OUkuggPxYe4qA@mail.gmail.com> <20120724115300.070d0ef7@pyramind.ukuu.org.uk> <CA+qZnSSazFWLKq5ao51JX=H-NCbwLD=6ypGXOeqQF72s7ZbTVA@mail.gmail.com>
In-Reply-To: <CA+qZnSSazFWLKq5ao51JX=H-NCbwLD=6ypGXOeqQF72s7ZbTVA@mail.gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 12:56 PM, tingwei liu wrote:
> On Tue, Jul 24, 2012 at 6:53 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> On Tue, 24 Jul 2012 18:39:20 +0800
>> tingwei liu <tingw.liu@gmail.com> wrote:
>>
>>> Suse 11 SP1 kernel panic。
>>>
>>> I can't debug it without debuginfo. Who can give me a link of sels
>>> 2.6.32.12-0.7.default.debug or give some advise.
>>
>> For distribution kernels (which tend to contain lots of other patches)
>> it is best to talk to your distribution support as a starter and/or their
>> forums.
>>
> I have report bug on suse website, but I haven't got any response until now!

Well, where exactly?

> Can you give some advice?
> I thought this maybe a kernel bug.

Yes, first upgrade to the latest kernel provided by Suse (2.6.32.59).

You can also try to reproduce with -vanilla flavour. This is a pure
upstream version with no suse patches (you will lose apparmor for example):
http://download.opensuse.org/repositories/Kernel:/SLE11-SP1/SUSE_SLE-11_SP1/

thanks,
-- 
js
suse labs
