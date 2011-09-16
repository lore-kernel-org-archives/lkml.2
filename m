Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab1IPNkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 09:40:12 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:55695 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab1IPNkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 09:40:11 -0400
MIME-Version: 1.0
In-Reply-To: <20110907203646.2a7b7833@schatten.dmk.lab>
References: <1280784368-4226-8-git-send-email-mcarlson@broadcom.com>
 <20110906170343.09252578@schatten.dmk.lab> <20110907012515.GA9038@mcarlson.broadcom.com>
 <20110907203646.2a7b7833@schatten.dmk.lab>
From: Francesco Piccinno <stack.box@gmail.com>
Date: Fri, 16 Sep 2011 15:39:30 +0200
Message-ID: <CAA7bCn4NTSppmAph9pxykpEfYT_tYoBFV8zReaKFgJqcu6=t7Q@mail.gmail.com>
Subject: Re: re add support for bcm5750
To: Florian Mickler <florian@mickler.org>
Cc: Matt Carlson <mcarlson@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Li <benli@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have contacted Broadcom asking for support and apparently there is
no way to fix the problem. Now I have a couple of questions: the use
of tg3 driver without a firmware expose the NIC to some risks or not?
And is there any chance to have the PCI IDs added back to tg3 module?
I do not want to modify and recompile the module at every version
bump.

Thanks for the support :)

--
Best regards,
Francesco Piccinno



On Wed, Sep 7, 2011 at 8:36 PM, Florian Mickler <florian@mickler.org> wrote:
> On Tue, 6 Sep 2011 18:25:15 -0700
> "Matt Carlson" <mcarlson@broadcom.com> wrote:
>
>> On Tue, Sep 06, 2011 at 08:03:43AM -0700, Florian Mickler wrote:
>> > Hi,
>> >
>> > in https://bugzilla.kernel.org/show_bug.cgi?id=42132 Francesco wrote:
>> >
>> > > I have a notebook (HP TC4400) which has a BCM5750 ethernet card inside. The
>> > > ouput of lspci is:
>> > >
>> > > 08:00.0 Ethernet controller [0200]: Broadcom Corporation NetXtreme BCM5750M
>> > > Gigabit Ethernet [14e4:167c]
>> > >
>> > > Commit 67b284d476bcb3d100e946da23d6cf9acfd0465c removed the support for this
>> > > device. I wish to have the support for this network card back again. Thanks!
>>
>> Hi Florian.  Are you experiencing the same problem?  We found that
>> Francesco's problem was that the firmware of his device was missing.  Do
>> you see :
>>
>> eth0: No firmware running
>>
>> messages?
>>
>
> Hi Matt!
> No, I was just browsing the regression list and found this entry but
> couldn't associate any action with it.
>
> This clears that up, thanks for the information and I will close this
> bug.
>
> Regards,
> Flo
>
