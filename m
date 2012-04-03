Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab2DCKa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 06:30:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55410 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab2DCKa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 06:30:56 -0400
MIME-Version: 1.0
In-Reply-To: <1333424865.26079.9.camel@joe2Laptop>
References: <1333415903.860.0.camel@mop> <1333420612.26079.6.camel@joe2Laptop>
 <CAPXgP12jX37GLgMJQuDYEi6q5A2Ma3d+e+_sNkFVdYfwsdMrtQ@mail.gmail.com> <1333424865.26079.9.camel@joe2Laptop>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 3 Apr 2012 12:30:35 +0200
Message-ID: <CAPXgP13fDRZtAvV651NPqQ2TgUEtb+MX1EhKhwirAgoiNOg5tQ@mail.gmail.com>
Subject: Re: [PATCH] printk(): add KERN_CONT where needed
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 3, 2012 at 05:47, Joe Perches <joe@perches.com> wrote:
> On Tue, 2012-04-03 at 05:00 +0200, Kay Sievers wrote:
>> On Tue, Apr 3, 2012 at 04:36, Joe Perches <joe@perches.com> wrote:
>> > A couple of other trivial comments:
>> > It's better to try to coalesce multiple printks(KERN_CONT
>> > (perhaps it's better to use pr_cont instead too)
>> > Branches with the same printks should be hoisted where
>> > possible.
>> Sure, please send patches for anything that is more appropriate to use here.
>> I did not want to change any logic which needs to be tested. I just
>> trivially added the obviously missing prefix, which solved the
>> problem, and which could be applied right away.
>
> I think you should do it "right" rather than add
> trivial markers.

The trivial markers _are_ correct. And they really fix things as soon
as we start storing machine-readable records with printk(), instead of
blindly glueing bytes together with each printk() call, for humans to
puzzle with them if things go wrong.

The stuff you propose is a pretty different story. I see your point,
but it's more 'cosmetics' in code than not simple correctness fixes.

Kay
