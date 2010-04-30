Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934322Ab0D3TWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:22:43 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:34958 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932606Ab0D3TWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:22:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:x-url:x-pgp-fp:x-pgp:date
         :in-reply-to:message-id:user-agent:mime-version:content-type;
        b=mOafYTusp3/UYR3YBSHqCQlTbH6og2At3njr5NyNN575hDov9I0HKn8hXMjhy2Gxl0
         Oxovt/2WB3jfTImoqnWXtjO0VPyCNKCuYqMBCzKvs2nsF201NH4wwpnR1i4iJ8f5b4lI
         7j0SFPKUBVMCpHOGgSBFnQjbIHQ0sBM3LHuY8=
From: Michal Nazarewicz <mina86@mina86.com>
To: Greg KH <greg@kroah.com>
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>, linux-usb@vger.kernel.org,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 3/8] USB: gadget: __init and __exit tags removed
References: <cover.1270835924.git.mina86@mina86.com>
	<3baf39971e1f49e98498f5d00e21df4302396252.1270835924.git.mina86@mina86.com>
	<e6cbed26355492a8cde57973da56bccbb55b85a1.1270835924.git.mina86@mina86.com>
	<aa83c43874f8aa490300d6bd03472646f2727eb1.1270835924.git.mina86@mina86.com>
	<20100429221529.GA16465@kroah.com> <87hbmtq2ua.fsf@erwin.mina86.com>
	<20100429232245.GA3227@kroah.com>
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Thu, 29 Apr 2010 22:41:48 -0700 (PDT)
In-Reply-To: <20100429232245.GA3227@kroah.com> (Greg KH's message of "Thu, 29
	Apr 2010 16:22:45 -0700")
Message-ID: <87d3xhpkdi.fsf@erwin.mina86.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Fri, Apr 09, 2010 at 09:21:20PM +0200, Michal Nazarewicz wrote:
>>>> @@ -85,7 +85,7 @@ MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");
>>>>   * This function returns the value of the function's bind(), which is
>>>>   * zero for success else a negative errno value.
>>>>   */
>>>> -int __init usb_add_function(struct usb_configuration *config,
>>>> +int __cold usb_add_function(struct usb_configuration *config,

>> Greg KH <greg@kroah.com> writes:
>>> What is the "__cold" for?
 
> On Thu, Apr 29, 2010 at 04:02:55PM -0700, Michal Nazarewicz wrote:
>> __init, among other things implies __cold so I left __cold leaving
>> out __section.

Greg KH <greg@kroah.com> writes:
> Hm, how about just dropping everything?  I don't think we need the
> __cold here then, right?

As you wish.  I'm about to resend the whole patchset (probably today or
Monday) with some new code so I'll include this change as well.

-- 
Best regards,                                         _     _
 .o. | Liege of Serenly Enlightened Majesty of      o' \,=./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz   (o o)
 ooo +--<mina86-tlen.pl>--<jid:mina86-jabber.org>--ooO--(_)--Ooo--
