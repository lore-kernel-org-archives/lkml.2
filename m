Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab1HOFUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:20:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45255 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab1HOFUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:20:23 -0400
Message-ID: <4E48AC7D.4030908@zytor.com>
Date: Sun, 14 Aug 2011 22:19:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Mike Waychison <mikew@google.com>, Greg KH <gregkh@suse.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Documentation: add Internal-reference-ID: patch tag
References: <20110729180028.6a2091b3.rdunlap@xenotime.net>	<20110730235644.GA29671@suse.de>	<CAGTjWtDXeMnHWZMmRezTSYmHr3D1N1KRXzzdjQh9HJMxvj8pwg@mail.gmail.com>	<4E359A74.7090408@zytor.com>	<20110813123401.76ffcfcc.rdunlap@xenotime.net>	<2d50505d-3500-47d8-84d4-b32850bdec7e@email.android.com> <20110814202322.16b50ff5.rdunlap@xenotime.net>
In-Reply-To: <20110814202322.16b50ff5.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2011 08:23 PM, Randy Dunlap wrote:
>>
>> No, that wouldn't work when there is more than one tag from different users.  And yes, I fully expect to see that.
>> --
>
> I guess that's a NAK or at least not consensus.
> Would you like to submit an alternative?
>

I would like to see the <id@owner> format I mentioned.

	-hpa
