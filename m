Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451Ab1JDWGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 18:06:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35355 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab1JDWGM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 18:06:12 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1110041404530.31654@pobox.suse.cz>
References: <1317452093-25555-1-git-send-email-iwamatsu@nigauri.org>
 <alpine.LNX.2.00.1110031402360.31654@pobox.suse.cz> <alpine.LNX.2.00.1110031415110.31654@pobox.suse.cz>
 <CABMQnV+y+yw-cY9CexT_eVWqsJFkT0ffZLx87y5CRuX=KiOtpQ@mail.gmail.com> <alpine.LNX.2.00.1110041404530.31654@pobox.suse.cz>
From: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Date: Wed, 5 Oct 2011 07:05:50 +0900
Message-ID: <CABMQnVJaxTpeGzLK=Qxizj2vHKFM_Gf7qDPLgUGuqauz4P9_GA@mail.gmail.com>
Subject: Re: [PATCH] HID: Add support MacbookAir 4,1 keyboard
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, "Joshua V. Dillon" <jvdillon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/4 Jiri Kosina <jkosina@suse.cz>:
> On Tue, 4 Oct 2011, Nobuhiro Iwamatsu wrote:
>
>> >> > Signed-off-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
>> >>
>> >> Applied, thank you.
>> >
>> Thanks.
>>
>> > Oh, and don't we BTW need the hid_mouse_ignore_list[] addition as well? Is
>> > the respective mouse being handled properly by appletouch driver?
>>
>> I don't work touchpad on MacbookAir yet.
>> But I think that the change is necessary when I show a past change.
>> And I think that I am necessary for MacbookAir 4,2.
>> I made patches, and I attached.
>
> After noticing that bcm5974 already supports mouse interfaces of these, I
> have already fixed it myself in my tree.
>
OK, Thanks for your fix.

Nobuhiro

-- 
Nobuhiro Iwamatsu
   iwamatsu at {nigauri.org / debian.org}
   GPG ID: 40AD1FA6
