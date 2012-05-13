Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab2EMCS0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 22:18:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38158 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2EMCSZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 22:18:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120512140918.GA1407@redhat.com>
References: <4fae23ca.68db440a.4bc9.22cc@mx.google.com>
	<4FAE272C.6080804@msgid.tls.msk.ru>
	<20120512112637.GA11577@localhost>
	<20120512140918.GA1407@redhat.com>
Date: Sun, 13 May 2012 10:18:24 +0800
Message-ID: <CAM_iQpVcY8vbtasYKeAcc4i-TX+JN+wLbF8hrDHqRahUJgcAwQ@mail.gmail.com>
Subject: Re: [PATCH] unmapped quotes
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Michael Tokarev <mjt@tls.msk.ru>,
        liwp.linux@gmail.com, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2012 at 10:09 PM, Johannes Weiner <jweiner@redhat.com> wrote:
> On Sat, May 12, 2012 at 07:26:37PM +0800, Fengguang Wu wrote:
>> On Sat, May 12, 2012 at 01:02:36PM +0400, Michael Tokarev wrote:
>> > On 12.05.2012 12:47, liwp.linux@gmail.com wrote:
>> > > - * If we're over `background_thresh' then the writeback threads are woken to
>> > > + * If we're over 'background_thresh' then the writeback threads are woken to
>> >
>> > I can't say the original is wrong.  Since these quotes don't have
>> > "open" and "close" versions like {} or () pairs does, people often
>> > use ` as opening and ' as closing - while staying within ascii.
>> > Alternatives are things like « » or other things, but these aren't
>> > ascii anymore.  So I'd say keep it alone... ;)
>>
>> Agreed. For example, latex uses ` and ' as opening and closing pairs.
>> That does look a bit weird for C and shell users ;)
>
> In some fonts, ` is actually symmetrical to '.
>
> If you change it to 'background_thresh', it will look like crap in my
> Sütterlin emacs.

Yup, see also,

http://english.stackexchange.com/questions/17695/any-reference-on-the-usage-of-a-backtick-and-single-quotation-mark-like-this/18669#18669
