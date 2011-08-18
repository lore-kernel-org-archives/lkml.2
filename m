Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab1HRQxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 12:53:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62001 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1HRQxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 12:53:35 -0400
MIME-Version: 1.0
In-Reply-To: <1313683211-sup-3134@shiny>
References: <CAPL5yKdvMtCo8qqqJGM-FXk7CmhkY98QeDa8uH=ZDFLjus7Wng@mail.gmail.com>
	<1313499055-sup-2296@shiny>
	<CAPL5yKc7wztLatbk-4sVDnTLeiSeeXaXZd45r_rxDhdtR3mtPg@mail.gmail.com>
	<4E4B181E.8000508@cn.fujitsu.com>
	<CAKcLGm-c8zEi+=j2M_QjvS3GGJezvN_DTbUwb-tZtjPj9ZhNrQ@mail.gmail.com>
	<1313683211-sup-3134@shiny>
Date: Thu, 18 Aug 2011 11:53:33 -0500
Message-ID: <CAKcLGm8rY+3TYpe=ivmNrsZgUcBcgk3-6RRe81vGComN2bqgMw@mail.gmail.com>
Subject: Re: processes stuck in llseek
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Dan Merillat <dan.merillat@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BTRFS Mailing list <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 11:00 AM, Chris Mason <chris.mason@oracle.com> wrote:
> Excerpts from Mitch Harder's message of 2011-08-18 11:40:17 -0400:
>> On Tue, Aug 16, 2011 at 8:23 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> > Dan Merillat wrote:
>> >> On Tue, Aug 16, 2011 at 8:51 AM, Chris Mason <chris.mason@oracle.com> wrote:
>> >>> Excerpts from Dan Merillat's message of 2011-08-15 23:59:50 -0400:
>> >>
>> >>> Dan Carpenter sent a patch for this, I'll get it queued up for rc3.
>> >>
>> >> Can you send it?  I'd like to test it to see if it fixes my system.
>> >
>> > Here it is.
>> >
>> > http://marc.info/?l=linux-btrfs&m=131176036219732&w=2
>> >
>>
>> Doesn't this patch rely on Josef's SEEK_HOLE/SEEK_DATA patch set which
>> isn't in the kernel yet?
>>
>> http://marc.info/?l=linux-btrfs&m=130927580606177&w=2
>
> It does, but the hang was reported on 3.1-rc1, which does have Josef's
> code.
>

Thanks.

That gives me some insights regarding the differences between the
'for-linus' and the 'for-linus-merged' branches.
