Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab1KCJgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 05:36:51 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41413 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1KCJgu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 05:36:50 -0400
MIME-Version: 1.0
In-Reply-To: <20111103031049.GA13681@zhy>
References: <1320264087-3413-1-git-send-email-john.stultz@linaro.org>
	<20111103031049.GA13681@zhy>
Date: Thu, 3 Nov 2011 17:36:49 +0800
Message-ID: <CAM_iQpV393oM4H_Ru3f7sbREiK8xQpD52nycADEuUqK4TJUT7g@mail.gmail.com>
Subject: Re: [PATCH] clocksource: Avoid selecting mult values that might
 overflow when adjusted
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        David Daney <ddaney.cavm@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 3, 2011 at 11:10 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Wed, Nov 02, 2011 at 01:01:27PM -0700, John Stultz wrote:
>> +     WARN_ONCE(timekeeper.mult+adj >
>> +                     timekeeper.clock->mult + timekeeper.clock->maxadj,
>> +                     "Adjusting more then 11%%");
>
>                        s/then/than ; s/%%/%\n ?

       %      A '%' is written.  No argument is converted.  The
complete conversion specification is '%%'.
