Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351Ab2FHAz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:55:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63520 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759244Ab2FHAzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:55:55 -0400
MIME-Version: 1.0
In-Reply-To: <1339108741.21222.21.camel@jtkirshe-mobl>
References: <CABawtvNv7LwT_awXscXGEid-1wes-+ZELc7YMLZqyo2h=h98UA@mail.gmail.com>
	<1339029671.10602.81.camel@jtkirshe-mobl>
	<804857E1F29AAC47BF68C404FC60A18428442D67@ORSMSX102.amr.corp.intel.com>
	<CABawtvNAtJ=W=rztnizPz=ZXGcLoGHPNJn4XUZMQyQJQ46nooQ@mail.gmail.com>
	<804857E1F29AAC47BF68C404FC60A18428444C0A@ORSMSX102.amr.corp.intel.com>
	<9DA1E3A1-025A-474C-811A-957B57E74911@gmail.com>
	<1339108741.21222.21.camel@jtkirshe-mobl>
Date: Fri, 8 Jun 2012 08:55:54 +0800
Message-ID: <CABawtvOuE+-eReeJ3xMUi9-8vuS9rkLRa4y1wro3EdTZpHg_FA@mail.gmail.com>
Subject: Re: [E1000-devel] [next-net PATCH] drivers/net/ethernet/intel/e1000e:
 fix unregistered net_device ethX name output by e1000e
From: Ethan Zhao <ethan.kernel@gmail.com>
To: jeffrey.t.kirsher@intel.com
Cc: "Allan, Bruce W" <bruce.w.allan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,
  That is OK, I would like to have a test if could share Allan's patch
for this issue.

Thanks.
Ethan


On Fri, Jun 8, 2012 at 6:39 AM, Jeff Kirsher
<jeffrey.t.kirsher@intel.com> wrote:
> It appears you are not understanding what Bruce and I have said.
>
> I am not adding your patch to my queue because Bruce has already a patch
> submitted to my queue which resolves the problem you reported.  So there
> is no need for a different patch from you to resolve the issue because
> it has already been taken care of by Bruce's patch.
>
> So NACK, and there is no need to begin another patch for this issue.
>
> If you find a different problem or issue with one of our drivers, feel
> free to submit a patch.  I am always open to patches from the community,
> just in this particular case, Bruce already had a patch that resolves
> this issue (in a more complete way).
>
> On Thu, 2012-06-07 at 23:02 +0800, Ethan.kernel@gmail wrote:
>> Jeffrey,
>>
>>         So, Could you help to put this patch in your queue if it worth 2 cents for some Linux users ?
>>
>> Or a NACK for any reason let me know just throw it and begin another.
>>
>> Thanks,
>> Ethan
>>
>> 在 2012-6-7，22:33，"Allan, Bruce W" <bruce.w.allan@intel.com> 写道：
>>
>> > Yes, my patch is different from yours.
>> >
>> >> -----Original Message-----
>> >> From: Ethan Zhao [mailto:ethan.kernel@gmail.com]
>> >> Sent: Wednesday, June 06, 2012 6:24 PM
>> >> To: Allan, Bruce W
>> >> Subject: Re: [E1000-devel] [next-net PATCH]
>> >> drivers/net/ethernet/intel/e1000e: fix unregistered net_device ethX
>> >> name output by e1000e
>> >>
>> >> Allan, So they are different patch ?
>> >> jeffrey, right ?
>> >>
>> >> Ethan
>> >>
>> >> On Thu, Jun 7, 2012 at 8:56 AM, Allan, Bruce W
>> >> <bruce.w.allan@intel.com> wrote:
>> >>>> -----Original Message-----
>> >>>> From: Jeff Kirsher [mailto:jeffrey.t.kirsher@intel.com]
>> >>>> Sent: Wednesday, June 06, 2012 5:41 PM
>> >>>> To: Ethan Zhao
>> >>>> Cc: e1000-devel@lists.sourceforge.net; Linux NICS; LKML
>> >>>> Subject: Re: [E1000-devel] [next-net PATCH]
>> >>>> drivers/net/ethernet/intel/e1000e: fix unregistered net_device ethX
>> >>>> name output by e1000e
>> >>>>
>> >>>> On Wed, 2012-06-06 at 22:57 +0800, Ethan Zhao wrote:
>> >>>>> commit ca3ccc6835943287b6f69e973c126a02bc4de409
>> >>>>> Author: ethan.zhao <ethan.kernel@gmail.com>
>> >>>>> Date:   Wed Jun 6 07:32:11 2012 -0700
>> >>>>>
>> >>>>>         modified:   drivers/net/ethernet/intel/e1000e/param.c
>> >>>>>
>> >>>>>     While e1000e_check_options() is called, netdev is not
>> >>>> registered,
>> >>>>> so the
>> >>>>>     e1000e driver will print out confused ethernet interface name
>> >>>>> (unregistered net_device) :
>> >>>>>
>> >>>>>     e1000e 0000:04:00.0:(unregistered net_device): Interrupt
>> >>>>> Throttling Rate (ints/sec) set to dynamic conservative mode
>> >>>>>
>> >>>>>     So change e_info() back to dev_printk() by simply redefine
>> >> the
>> >>>>> e_info macro used by
>> >>>>>     e1000e_check_options() and e1000_validate_option
>> >>>>>
>> >>>>>     after applied this patch, we got:
>> >>>>>
>> >>>>>     e1000e 0000:04:00.0: Interrupt Throttling Rate (ints/sec) set
>> >> to
>> >>>>> dynamic conservative mode
>> >>>>>     e1000e 0000:04:00.0: irq 95 for MSI/MSI-X
>> >>>>
>> >>>> NACK, I currently have a patch in my queue from Bruce Allan to
>> >> resolve
>> >>>> this issue.  I should be pushing the patch upstream in a few days.
>> >>>
>> >>> For clarification, the problem with the NACK'ed patch is it is
>> >> missing a
>> >>> number of instances of the same issue that is meant to be addressed
>> >> by the
>> >>> patch.
>> >>>
>
>
