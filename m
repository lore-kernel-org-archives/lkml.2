Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab1HORkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 13:40:15 -0400
Received: from smtp-out.google.com ([74.125.121.67]:59294 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1HORkN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 13:40:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=qQrr15VZhzsl1Fs0mhXnCc96EkQG1TAWx0Zfy1xlqMcK3Apc3IPs99e+aBqegtZEo
	DN6jT1y28Ack0/IteU65w==
MIME-Version: 1.0
In-Reply-To: <4E48AC7D.4030908@zytor.com>
References: <20110729180028.6a2091b3.rdunlap@xenotime.net> <20110730235644.GA29671@suse.de>
 <CAGTjWtDXeMnHWZMmRezTSYmHr3D1N1KRXzzdjQh9HJMxvj8pwg@mail.gmail.com>
 <4E359A74.7090408@zytor.com> <20110813123401.76ffcfcc.rdunlap@xenotime.net>
 <2d50505d-3500-47d8-84d4-b32850bdec7e@email.android.com> <20110814202322.16b50ff5.rdunlap@xenotime.net>
 <4E48AC7D.4030908@zytor.com>
From: Mike Waychison <mikew@google.com>
Date: Mon, 15 Aug 2011 10:39:48 -0700
Message-ID: <CAGTjWtD2Xz6gE6mDM6zOqDic=JZ5A9UtRzTLnUTAputc=KEZ+Q@mail.gmail.com>
Subject: Re: [PATCH] Documentation: add Internal-reference-ID: patch tag
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Greg KH <gregkh@suse.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 10:19 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 08/14/2011 08:23 PM, Randy Dunlap wrote:
>>>
>>> No, that wouldn't work when there is more than one tag from different
>>> users.  And yes, I fully expect to see that.
>>> --
>>
>> I guess that's a NAK or at least not consensus.
>> Would you like to submit an alternative?
>>
>
> I would like to see the <id@owner> format I mentioned.

Is there a middle ground if we say:

Internal-reference-ID: <arbitrarytextforid@owner>

so

Internal-reference-ID: <2011.0729.id1@rdunlap>
Internal-reference-ID: <bug-45322143@google>

?
