Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750817Ab1KAFPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 01:15:04 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44886 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab1KAFPC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 01:15:02 -0400
MIME-Version: 1.0
In-Reply-To: <574299906.69412.1320054001912.JavaMail.mail@webmail05>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
	<20111030212644.GA7106@khazad-dum.debian.net>
	<815860869.50724.1320011477430.JavaMail.mail@webmail17>
	<20111031091607.GB7106@khazad-dum.debian.net>
	<574299906.69412.1320054001912.JavaMail.mail@webmail05>
Date: Mon, 31 Oct 2011 22:15:00 -0700
Message-ID: <CADVo6625Jg9zY2hejFXD_2TrbZKHm3seNGobaQg2RKta7Nor_Q@mail.gmail.com>
Subject: Re: Re: HT (Hyper Threading) aware process scheduling doesn't work as
 it should
From: ffab ffa <ffab78@gmail.com>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: hmh@hmh.eng.br, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

are you sure of the cpu terminology? I used few  i7-2600K  machine
and  the  /proc/cpuinfo shows that the cores thread siblings are 0-4,
1-5, 2-6 and 3-7
can you share your /proc/cpuinfo

On Mon, Oct 31, 2011 at 2:40 AM, Artem S. Tashkinov <t.artem@lycos.com> wrote:
>> On Oct 31, 2011, Henrique de Moraes Holschuh  wrote:
>>
>> On Sun, 30 Oct 2011, Artem S. Tashkinov wrote:
>> > > Please make sure both are set to 0.  If they were not 0 at the time you
>> > > ran your tests, please retest and report back.
>> >
>> > That's 0 & 0 for me.
>>
>> How idle is your system during the test?
>
> load average: 0.00, 0.00, 0.00
>
> As I've mentioned great many times I run this test on a completely idle system
> (i.e. I even `init 3` in advance to avoid any unexpected CPU usage spikes
> caused by unrelated processed).
>
> I have to insist that people conduct this test on their own without trusting my
> words. Probably there's something I overlook or don't fully understand but from
> what I see, there's a serious issue here (at least Microsoft XP and 7 work exactly
> the way I believe an OS should handle such a load).
>
> Artem
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
