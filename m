Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab2DIR7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:59:09 -0400
Received: from mga10.intel.com ([192.55.52.92]:28230 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753226Ab2DIR7H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:59:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120409174823.GA31394@kroah.com>
References: <4F7B52D8.101@fb.com>
	<20120403215832.0520f93d@pyramind.ukuu.org.uk>
	<20120409164759.GA8800@kroah.com>
	<CABE8wwsHZLiihEReRQwkk+SufkmBw2W4n-WibQgS-rEOnKNGMA@mail.gmail.com>
	<20120409174823.GA31394@kroah.com>
Date: Mon, 9 Apr 2012 10:59:04 -0700
Message-ID: <CABE8wwvZYi1e+RUJ2zd7fkkPd5Wi3dsVWJXqMgeOPtj3y88A5A@mail.gmail.com>
Subject: Re: [PATCH 1/2] 8250_pci: Replace commits 448ac154 and e86ff4a
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, sudhakar <sudhakar@fb.com>,
        linux-serial@vger.kernel.org, alan@linux.intel.com,
        nhan.h.mai@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 10:48 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Apr 09, 2012 at 09:53:47AM -0700, Williams, Dan J wrote:
>> On Mon, Apr 9, 2012 at 9:47 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Tue, Apr 03, 2012 at 09:58:32PM +0100, Alan Cox wrote:
>> >> On Tue, 3 Apr 2012 12:43:20 -0700
>> >> sudhakar <sudhakar@fb.com> wrote:
>> >>
>> >> >
>> >> > From: Sudhakar Mamillapalli <sudhakar@fb.com>
>> >> >
>> >> >
>> >> > The following commits don't completely fix the KT serial missing
>> >> > interrupt problems.  So they have been replaced instead by
>> >> > enabling serial backup timer.  The iir-once + msi tried approach tried
>> >> > to enforce one read of the iir per THRE event, but its defeated by any
>> >> > other event occurring at the wrong time, particularly MSR events.
>> >> >
>> >> > 448ac15 serial/8250_pci: setup-quirk workaround for the kt serial controller
>> >> > e86ff4a serial/8250_pci: init-quirk msi support for kt serial controller
>> >>
>> >> These are already in tree. If you are reversing them and adding a
>> >> different fix then please post the series as
>> >>
>> >> - two revert patches exactly reverting the two commits
>> >> - a follow on patch or two adding the replacement
>> >>
>> >> That makes it much easier to review and much more obvious. It also helps
>> >> make testing simpler.
>> >
>> > I agree, Sudhakar, can you please redo these 2 patches?
>> >
>>
>> Hi Greg,
>>
>> This was in the series:
>>
>> [PATCH 0/6] rework quirks for the "kt" serial port [1]
>>
>> ...but I have just noticed it collides with current git, and I also
>> need to address Stephen's comments for Tegra.  Expect a v2 shortly.
>
> Ok, thanks.  Note, I just applied the first 3 to go to Linus soon, those
> didn't need to be reworked, right?
>

Correct, those were ready to go.  Thanks!

--
Dan
