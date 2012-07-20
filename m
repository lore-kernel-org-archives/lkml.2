Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab2GTJXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 05:23:35 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57191 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab2GTJXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 05:23:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120719140826.GD2761@redhat.com>
References: <20120718171812.GC21746@redhat.com> <CAPXgP12PioibfQhtAB0fCzL1MXmZvfvQqOGu_ZM0D8Sx4Vq7+w@mail.gmail.com>
 <20120718175625.GD21746@redhat.com> <CAPXgP12YasX6mBVOamO8Tk1mcFJ04XWh5CjuTRxhRShncgVCtA@mail.gmail.com>
 <20120719135736.GC2761@redhat.com> <20120719140826.GD2761@redhat.com>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 20 Jul 2012 11:23:10 +0200
Message-ID: <CAPXgP13W_aqky++LkHeHBUzKFTYNiTJQpchpHLCVDAdYihu5ig@mail.gmail.com>
Subject: Re: [PATCH] printk: Export struct log size and member offsets through vmcoreinfo
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartmann <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 4:08 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Jul 19, 2012 at 09:57:36AM -0400, Vivek Goyal wrote:
>> On Thu, Jul 19, 2012 at 11:38:57AM +0200, Kay Sievers wrote:

>> > If we would swap the 5 + 3 bit field byte declaration, and add
>> > __packed, we can still not rely on the level to be consistently the
>> > lower 3 bits of the byte, right?
>
> I think I missed your point in last response. Are you saying that retain
> bit fields  for flags and level, and add __packed() and that will make sure
> level bits are always lowest 3bits?

It was more a question, I don't know how reliable that would be.

> I am really not sure how that is going
> to work. Also if you want to add more fields to struct log down the line,
> it will be a problem to determine the offset of byte where level bits are
> stored.

I guess, we could make sure that it's always the lowest 3 bits of a
byte. But the question if that is safe to do at all still remains. :)

Kay
