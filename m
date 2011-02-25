Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab1BYUWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:22:05 -0500
Received: from smtp-out.google.com ([74.125.121.67]:6166 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab1BYUWC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:22:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=htvpYU3jgh16UT1UOnUFID6HHCbxsXYtKLARsRf7KQ4FJrBIWaEbvxyN7IPrArujJo
         d2zCwCEvkwrr5LXJ0azg==
MIME-Version: 1.0
In-Reply-To: <8yak4go9bxw.fsf@huya.qualcomm.com>
References: <1298585954-22422-1-git-send-email-kheitke@codeaurora.org>
	<1298585954-22422-3-git-send-email-kheitke@codeaurora.org>
	<1298600621.17118.27.camel@m0nster>
	<8yak4go9bxw.fsf@huya.qualcomm.com>
Date: Fri, 25 Feb 2011 12:21:57 -0800
Message-ID: <AANLkTi=oGsOnQJBPjvrg+i0iHzRN0aQt3imyi17k1QkF@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] msm: add single-wire serial bus interface (SSBI) driver
From: Brian Swetland <swetland@google.com>
To: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>,
        Kenneth Heitke <kheitke@codeaurora.org>, dima@android.com,
        linux-arm-msm@vger.kernel.org, tsoni@codeaurora.org,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 11:00 AM, David Brown <davidb@codeaurora.org> wrote:
> On Thu, Feb 24 2011, Daniel Walker wrote:
>
>>> Based on a patch by Dima Zavin <dima@android.com> that can be found at:
>>> http://android.git.kernel.org/?p=kernel/msm.git;a=commitdiff;h=eb060bac4
>>
>> I don't really like links in the commit text, cause as soon as Google
>> deletes this tree the link is worthless.
>
> I'm not sure how to better convey the information.  The tree is at least
> on kernel.org, and there's good useful information there that works
> now.  Links in commit text seem fairly common.
>
> I think it is helpful to demonstrate that Ken is trying to be diligent
> about indicating where the code comes from.

We do also keep older branches around, since this is how we publish
kernel sources when we ship devices.  So while I can't be sure these
links will work *forever*, barring mishap they should exist for quite
a while.

Brian
