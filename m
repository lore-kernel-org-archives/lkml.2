Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab1DHJHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 05:07:12 -0400
Received: from ftp.sofha.de ([82.144.60.99]:38591 "EHLO ftp.sofha.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab1DHJHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 05:07:10 -0400
Message-ID: <4D9ED03C.2000706@snafu.de>
Date: Fri, 08 Apr 2011 11:07:08 +0200
From: Oncaphillis <oncaphillis@snafu.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Xiaofan Chen <xiaofanc@gmail.com>, libusb-devel@lists.sourceforge.net,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Libusb-devel] Kernel bug message and missing data on	libusb_interrupt_transfer
References: <Pine.LNX.4.44L0.1104051040440.1972-100000@iolanthe.rowland.org> <4D9C4262.1010704@snafu.de>
In-Reply-To: <4D9C4262.1010704@snafu.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2011 12:37 PM, Oncaphillis wrote:
> On 04/05/2011 04:42 PM, Alan Stern wrote:
>> On Tue, 5 Apr 2011, Oncaphillis wrote:
>>
>>> On 04/05/2011 04:13 PM, Alan Stern wrote:
>>>> On Tue, 5 Apr 2011, Oncaphillis wrote:
>>>>
>>>>> Now I get
>>>>>
>>>>> <snip>
>>>>> ------------[ cut here ]------------
>>>>> kernel BUG at mm/slub.c:2808!
>>>>> invalid opcode: 0000 [#2] SMP
>>>> Can you duplicate this using either a 2.6.37 or 2.6.38 kernel?
>>>>
>>>> Alan Stern
>>>>
>>> The highest kernel version we've tried (as far as i remember) was the
>>> 2.6.36. Have there been issues which might have been solved betwen 36
>>> and 3(7|8) ?
>> I don't know.  But the core kernel developers always want to hear about
>> problems reported against the most recent version possible.  If you
>> could test 2.6.39-rc1 (or -rc2, which should be released in a day or
>> so), that would be even better.
> Ok -- kernel 2.6.38.2 together with libusb-1.0.8 seems to behave well.
> This was only a minimal overnight test. Not the full functionality we
> are trying to implement. But it looks promising.
>
>    Thank you
>
>    O.
>
Just a short update,

  It doesn't seem to have anything to do with the libsub-1.0.x) version but
with the --(enable|disable)-timerfd option of libusb configure. If 
libusb was
configured with --disable-timerfd, which was the case for our 1.0.6 libusb
I get the kernel bug message in in slub.c module and eventually a
kernel freeze. This holds true for libusb-1.0.8 and kernel 2.6.38.2

O.

>>> I'll give it a try.
>> Thanks.
>>
>> Alan Stern
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> ------------------------------------------------------------------------------
> Xperia(TM) PLAY
> It's a major breakthrough. An authentic gaming
> smartphone on the nation's most reliable network.
> And it wants your games.
> http://p.sf.net/sfu/verizon-sfdev
> _______________________________________________
> Libusb-devel mailing list
> Libusb-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/libusb-devel

