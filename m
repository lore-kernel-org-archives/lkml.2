Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab2HULLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:11:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62078 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2HULLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:11:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAOTypNS40FOJ=D=sRigQaYJumXpCfH9Lu1c2B3jXy6epQuumVA@mail.gmail.com>
References: <1345179867-8266-1-git-send-email-yamanetoshi@gmail.com>
	<1345179920-8303-1-git-send-email-yamanetoshi@gmail.com>
	<20120817074644.GL4559@mwanda>
	<CAOTypNS_rbQK2rPDWenFahiz5Z+cufPTjRy-aABqW01c3DWmYQ@mail.gmail.com>
	<20120817131941.GA25079@kroah.com>
	<CAOTypNS40FOJ=D=sRigQaYJumXpCfH9Lu1c2B3jXy6epQuumVA@mail.gmail.com>
Date: Tue, 21 Aug 2012 20:11:20 +0900
Message-ID: <CAOTypNQUFTVGc64BtB2VGAZ+JD4oVTXtmgdKVdzKF_7Kouttnw@mail.gmail.com>
Subject: Re: [PATCH 2/5] staging/vme: fix checkpatch warning
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 11:30 PM, Toshiaki Yamane <yamanetoshi@gmail.com> wrote:
> On Fri, Aug 17, 2012 at 10:19 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> On Fri, Aug 17, 2012 at 05:27:53PM +0900, Toshiaki Yamane wrote:
>>> On Fri, Aug 17, 2012 at 4:46 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>>> > You've got the same subject repeated 5 times.
>>> >
>>> > It would be better to merge all the vme_user.c printk fixes into
>>> > one patch.
>>> > [patch 1/3] Staging: vme: Fix a white space issue
>>> > [patch 2/3] Staging: vme: Use pr_ printks in vme_user.c
>>> > [patch 3/3] Staging: vme: Use pr_ printks in vme_pio2_core.c
>>> >
>>> > It's not a huge deal, it just seems like there was some confusion on
>>> > how to break patches up.
>>>
>>>
>>> Thanks for your reply!
>>> I will try to fix it.
>>
>> Please do, I can't take it as-is.
>
> I will stop, if you say so.

Greg-san,

I have misunderstood your reply. I am sorry...
I will send a patch from now.

-- 

Regards,


 .
  .
...

Yamane Toshiaki

yamanetoshi@gmail.com
