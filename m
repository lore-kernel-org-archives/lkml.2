Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab1LLTOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 14:14:14 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39976 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab1LLTOL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 14:14:11 -0500
MIME-Version: 1.0
In-Reply-To: <20111212190526.GA12332@suse.de>
References: <20111209172316.GA24144@kroah.com>
	<CA+5PVA4N5Vu+9TjEsbVc=KW3q7kqEKQEME=pspP7OomQUX9dYw@mail.gmail.com>
	<20111212190526.GA12332@suse.de>
Date: Mon, 12 Dec 2011 14:14:09 -0500
Message-ID: <CA+5PVA4vjX6A0sK5RkiwYtBHD9wQyWv+CgejvXsWnbJZWqC7FQ@mail.gmail.com>
Subject: Re: Linux 3.1.5
From: Josh Boyer <jwboyer@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 2:05 PM, Greg KH <gregkh@suse.de> wrote:
> On Mon, Dec 12, 2011 at 01:42:42PM -0500, Josh Boyer wrote:
>> On Fri, Dec 9, 2011 at 12:23 PM, Greg KH <gregkh@suse.de> wrote:
>> > I'm announcing the release of the 3.1.5 kernel.
>> >
>> > All users of the 3.1 kernel series must upgrade.
>>
>> <snip>
>>
>> > Thomas Poussevin (1):
>> >      USB: EHCI: fix HUB TT scheduling issue with iso transfer
>>
>> Hrm... this was added in 3.1.3, then reverted for 3.1.4 because it
>> broke various devices:
>>
>> http://thread.gmane.org/gmane.linux.kernel/1220960/focus=1221485
>>
>> now it seems to be back in 3.1.5.  Was there another commit that was
>> added to solve the other issues?
>
> Yes, the one right after it.

Doh.  I hadn't looked in git yet, so I missed it.  Sorry for the noise.

josh
