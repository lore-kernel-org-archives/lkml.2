Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab0KPQcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 11:32:21 -0500
Received: from smtp-out.google.com ([216.239.44.51]:14883 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab0KPQcU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 11:32:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=D+AFIEi8xjI+FniMQtVJ3v2qFXZoOZ+zI6rz8E/OLY4lTT2iCmuNsx3CQljp6duu+3
         onle3CGljax9GAQVvNCA==
MIME-Version: 1.0
In-Reply-To: <1289921196.5169.176.camel@maggy.simson.net>
References: <1289900042.27424.253.camel@debian> <AANLkTi=OK+B537S5D8H4=yV5zC8+RksnfYgoKsqEyk5+@mail.gmail.com>
 <1289921196.5169.176.camel@maggy.simson.net>
From: Nikhil Rao <ncrao@google.com>
Date: Tue, 16 Nov 2010 08:31:57 -0800
Message-ID: <AANLkTinrtz36tDZT2C39aVRsws-wmRraLGsMZ8_zxFA+@mail.gmail.com>
Subject: Re: [performance bug] volanomark regression on 37-rc1
To: Mike Galbraith <efault@gmx.de>
Cc: Rakib Mullick <rakib.mullick@gmail.com>, "Alex,Shi" <alex.shi@intel.com>,
        a.p.zijlstra@chello.nl, mingo@elte.hu, linux-kernel@vger.kernel.org,
        "Chen, Tim C" <tim.c.chen@intel.com>, zheng.z.yan@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 7:26 AM, Mike Galbraith <efault@gmx.de> wrote:
> On Tue, 2010-11-16 at 20:38 +0600, Rakib Mullick wrote:
>
>> Does VolanoMark is used for scheduler benchmarking? If I'm not wrong,
>> I don't think it directly relates to scheduler benchmarking.
>
> It's not generally considered to be a wonderful benchmark, but it is a
> good indicator, and worth keeping an eye on IMHO.
>
> I don't recall whether that patch works with the idle testcase without
> resetting the throttle, or if it's only a bit less effective.  If it's
> only a little less effective, I'd be inclined to just whack the reset as
> Alex did.  Whatever is done has to prevent high frequency balancing.
>

>From what I recall, I think removing the reset makes the original
patch a little less effective. I agree that we can remove the reset if
it hurts high frequency balancing.

-Thanks,
Nikhil
