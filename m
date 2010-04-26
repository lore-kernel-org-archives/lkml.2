Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab0DZGYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 02:24:51 -0400
Received: from smtp-out.google.com ([74.125.121.35]:52960 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab0DZGYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 02:24:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=a1NkgGbFM/GmzErfrGCnPCdc3MyJg89Bucez18BwzUM3jaw0tDGMMq4lX3mPd80Ut
	pLcmIYA79KXa5Gkfo/qBQ==
MIME-Version: 1.0
In-Reply-To: <4BD49D9D.7020004@oracle.com>
References: <1271984938-13920-1-git-send-email-arve@android.com>
	 <1271984938-13920-2-git-send-email-arve@android.com>
	 <1271984938-13920-3-git-send-email-arve@android.com>
	 <1271984938-13920-4-git-send-email-arve@android.com>
	 <1271984938-13920-5-git-send-email-arve@android.com>
	 <1271984938-13920-6-git-send-email-arve@android.com>
	 <20100423135853.478af057.randy.dunlap@oracle.com>
	 <20100425181517.GA22676@kroah.com> <4BD49D9D.7020004@oracle.com>
Date: Sun, 25 Apr 2010 23:24:46 -0700
Message-ID: <p2xa55d774e1004252324i4dca8cc3y1ffacec838c436f8@mail.gmail.com>
Subject: Re: [PATCH 5/9] PM: suspend_block: Add debugfs file
From: Brian Swetland <swetland@google.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>, "Arve Hj?nnev?g" <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 25, 2010 at 12:53 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On 04/25/10 11:15, Greg KH wrote:
>> On Fri, Apr 23, 2010 at 01:58:53PM -0700, Randy Dunlap wrote:
>>> On Thu, 22 Apr 2010 18:08:54 -0700 Arve Hj?nnev?g wrote:
>>>
>>>> Report active and inactive suspend blockers in
>>>> /sys/kernel/debug/suspend_blockers.
>>>
>>>
>>> This looks more like user interface information than it does debug information.
>>> If that's correct, it shouldn't be in debugfs.
>>
>> It's debug-like information, and has more than one value per file, so
>> debugfs seems like the proper place for it.  I have no objection to it
>> going there.
>
> I have no objection if it really is debug info, but I'm not convinced
> of that yet.

Our most common use of this information is to capture it in bugreports
(along with process lists, system/radio logs, memory stats, etc) as
one additional piece of data used to diagnose a misbehaving device
(most commonly to answer the "why does the battery seem to be draining
too quickly?" question).

Brian
