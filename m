Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab0CTT1X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 15:27:23 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:52449 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab0CTT1W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 15:27:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aQ6Gkxu+VfKEpmf2Y8DZO1TvlFcDvVw+PPh+W3ENSRmSlzA7sf+1Ke+mvxaj6/e+IR
         cv2BlYCJp9f5XV0sIRWss8KSFX/gLBvKOj/QARnb7TWBEpdVY47csCH/I6LAmbDiy+Nu
         UsOlyylwy63wZthTrZREpuwxqHqHvQQwroyFA=
MIME-Version: 1.0
In-Reply-To: <167e8a331003192151o593809bbhcda68e284185dd4a@mail.gmail.com>
References: <4BA358DB.20708@enmesh.se>
	 <167e8a331003192151o593809bbhcda68e284185dd4a@mail.gmail.com>
Date: Sun, 21 Mar 2010 00:57:20 +0530
Message-ID: <5d5443651003201227w27314533w6be3cdd8fb9bf5aa@mail.gmail.com>
Subject: Re: input: mt: Software finger tracking in the kernel?
From: Trilok Soni <soni.trilok@gmail.com>
To: Ping Cheng <pinglinux@gmail.com>
Cc: Henrik Rydberg <rydberg@enmesh.se>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ping,

On Sat, Mar 20, 2010 at 10:21 AM, Ping Cheng <pinglinux@gmail.com> wrote:
> On Fri, Mar 19, 2010 at 3:58 AM, Henrik Rydberg <rydberg@enmesh.se> wrote:
>> Hi Dmitry,
>>
>> there is an ongoing discussion about adding multitouch to X
>> (http://lists.x.org/archives/xorg-devel/2010-March/006206.html), which is
>> beginning to take on more solid form.
>>
>> One of the suggestions emerging from that discussion is to add the software
>> finger tracking to the kernel. Back in summer 2009 when I thought about this, I
>> disregarded it as being too experimental. I have since then reconsidered,
>> starting to think it really is the right place.
>>
>> The MT protocol allows applications to take advantage of multi-contact hardware,
>> but leaves the problems of finger tracking and filtering to the user. Arguably,
>> no application can make good use of MT without these, so the problem is pushed
>> forward, in this case to evdev or equivalent.
>>
>> The knowledge of signal-to-noise ratios and prior input states resides in the
>> kernel. Because of this, the finger matching and filtering would naturally
>> reside within the kernel.
>>
>> So, if there were to appear patches to include matching in the input core, would
>> you consider them? :-)
>
> I support the idea to add a tracking ID and a filter to _MT_.  I'd
> also like to make the filtering method more "device driver developer"
> friendly, i.e., give the developer the option to turn the filter on or
> off.  If you plan to use a constant for the filtering method, please
> allow the developer to choose that constant too.
>
> Another attribute associated with _MT_ is the pressure/capacity.
> Report this value would offer more room for MT-aware application to
> add new features.

We have ABS_MT_PRESSURE added recently. I hope you are asking the same.


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
