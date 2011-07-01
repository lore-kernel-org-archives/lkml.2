Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1GABU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 21:20:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41089 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab1GABU2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 21:20:28 -0400
MIME-Version: 1.0
In-Reply-To: <4E0D191C.5090208@linux.intel.com>
References: <1309473108-5337-1-git-send-email-Gregory.Dietsche@cuw.edu>
	<tip-a5fd117a8fda8621e1ae1bb3b8d55e4c0ebabd94@git.kernel.org>
	<4E0D1400.7020107@zytor.com>
	<20110701004121.GA18671@farmergreg.com>
	<4E0D191C.5090208@linux.intel.com>
Date: Thu, 30 Jun 2011 21:20:26 -0400
Message-ID: <BANLkTimO30XXhzQt15tDK1-+ch8GcH4bjw@mail.gmail.com>
Subject: Re: [tip:x86/cleanups] x86, smpboot: Mark names[] array as const
From: Brian Gerst <brgerst@gmail.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Greg Dietsche <greg@farmergreg.com>, "H. Peter Anvin" <hpa@zytor.com>,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        Gregory.Dietsche@cuw.edu, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 8:47 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 06/30/2011 05:41 PM, Greg Dietsche wrote:
>> On Thu, Jun 30, 2011 at 05:25:36PM -0700, H. Peter Anvin wrote:
>>> On 06/30/2011 05:21 PM, tip-bot for Greg Dietsche wrote:
>>>> +   const char const *names[] = { "ID", "VERSION", "SPIV" };
>>>         ^^^^^^^^^^^^^^^^
>>>
>>> Doesn't make sense, patch removed...
>>>
>> could you explain a little more? I don't see my mistake.
>> it compiles and is running on my box currently.
>>

One const is for the strings, the other is for the array of pointers.

--
Brian Gerst
